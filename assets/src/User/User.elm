port module User.User exposing (..)

import Api exposing (ApiError, handleFailure)
import CommonElements exposing (formError)
import CommonMessages
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)
import Routing
import User.Api exposing (LoginResponse, loginFacebook, loginPassword)
import User.Decoder exposing (getToken)


type Msg
    = LoginPassword String String
    | LoginPasswordResponse (WebData LoginResponse)
    | LoginFacebookResponse (WebData LoginResponse)
    | LoginFacebook
    | Logout
    | LoginFieldChanged String
    | PasswordFieldChanged String
    | FacebookLoggedInResult String
    | Parent CommonMessages.Msg


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


type LoginStatus
    = NotLoggedIn
    | FacebookLoggedIn
    | PasswordLoggedIn


type alias Model =
    { login : String
    , password : String
    , loginPasswordResponse : WebData LoginResponse
    , loginFacebookResponse : WebData LoginResponse
    , loginStatus : LoginStatus
    , flags : Flags
    }


init : Flags -> Model
init flags =
    let
        ( initialLoginStatus, token ) =
            case flags.initialState.token of
                Just t ->
                    case flags.initialState.loginType of
                        Just "password" ->
                            ( PasswordLoggedIn, t )

                        Just "facebook" ->
                            ( FacebookLoggedIn, t )

                        _ ->
                            ( NotLoggedIn, "" )

                Nothing ->
                    ( NotLoggedIn, "" )
    in
    { login = ""
    , password = ""
    , loginPasswordResponse = RemoteData.NotAsked
    , loginFacebookResponse = RemoteData.NotAsked
    , loginStatus = initialLoginStatus
    , flags = flags
    }



-- PORTS


port facebookLoggedIn : (String -> msg) -> Sub msg


port facebookNotLoggedIn : (String -> msg) -> Sub msg


port facebookLogin : {} -> Cmd msg


port facebookLogout : {} -> Cmd msg


port storeToken : ( String, String ) -> Cmd msg


port deleteToken : {} -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ facebookLoggedIn FacebookLoggedInResult
        ]


updateLoginStatus : RemoteData.RemoteData e a -> LoginStatus -> LoginStatus -> LoginStatus
updateLoginStatus result current wanted =
    case result of
        RemoteData.Success _ ->
            wanted

        _ ->
            current


maybeStoreToken : RemoteData.RemoteData e LoginResponse -> String -> Cmd msg
maybeStoreToken result loginType =
    case result of
        RemoteData.Success u ->
            storeToken ( u.token, loginType )

        _ ->
            Cmd.none


maybeResetForm : RemoteData.RemoteData e a -> Model -> Model
maybeResetForm result model =
    case result of
        RemoteData.Success u ->
            { model | login = "", password = "" }

        _ ->
            model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginPassword login password ->
            ( model, loginPassword model.flags model.login model.password LoginPasswordResponse )

        LoginFacebook ->
            ( model, facebookLogin {} )

        LoginPasswordResponse response ->
            let
                _ =
                    Debug.log "update LoggedIn " "LoginPasswordResponse"

                loginStatus =
                    updateLoginStatus response model.loginStatus PasswordLoggedIn

                model_ =
                    maybeResetForm response model
            in
            ( { model_ | loginStatus = loginStatus, loginPasswordResponse = response }, maybeStoreToken response "password" )

        LoginFacebookResponse response ->
            let
                _ =
                    Debug.log "update LoggedIn " "LoginFacebookResponse"

                loginStatus =
                    updateLoginStatus response model.loginStatus FacebookLoggedIn

                model_ =
                    maybeResetForm response model
            in
            ( { model_ | loginStatus = loginStatus, loginFacebookResponse = response }, maybeStoreToken response "facebook" )

        LoginFieldChanged value ->
            ( { model | login = value }, Cmd.none )

        PasswordFieldChanged value ->
            ( { model | password = value }, Cmd.none )

        FacebookLoggedInResult json ->
            let
                _ =
                    Debug.log "update LoggedIn " json

                token =
                    getToken json
            in
            ( model, loginFacebook model.flags token LoginFacebookResponse )

        Logout ->
            let
                _ =
                    Debug.log "logout " model.loginStatus
            in
            case model.loginStatus of
                NotLoggedIn ->
                    ( model, Cmd.none )

                FacebookLoggedIn ->
                    ( { model | loginStatus = NotLoggedIn }, Cmd.batch [ facebookLogout {}, deleteToken {} ] )

                PasswordLoggedIn ->
                    ( { model | loginStatus = NotLoggedIn }, deleteToken {} )

        Parent msg_ ->
            ( model, Cmd.none )


loginPasswordForm : Model -> Html Msg
loginPasswordForm model =
    let
        error =
            model.loginPasswordResponse |> handleFailure
    in
    Html.form [ onSubmit (LoginPassword model.login model.password), class "centered" ]
        [ Html.label []
            [ text "Login"
            , input [ value model.login, onInput LoginFieldChanged ] []
            , formError error "login"
            ]
        , Html.label []
            [ text "Hasło"
            , input [ type_ "password", value model.password, onInput PasswordFieldChanged ] []
            , formError error "password"
            ]
        , formError error "_"
        , div [ class "formRow" ]
            [ Html.button [ type_ "submit" ] [ text "Zaloguj" ]
            , registerButton
            ]
        , loginFacebookForm model
        ]


loginFacebookForm : Model -> Html Msg
loginFacebookForm model =
    let
        error =
            model.loginFacebookResponse |> handleFailure
    in
    Html.form [ onSubmit LoginFacebook, class "loginFacebookForm" ]
        [ Html.button [ type_ "submit" ] [ text "Zaloguj przez Facebook" ]
        , formError error "_"
        ]


logoutForm : Model -> Html Msg
logoutForm model =
    Html.form [ onSubmit Logout ]
        [ Html.button [ type_ "submit" ] [ text "Wyloguj" ] ]


registerButton =
    a
        [ Routing.linkHref Routing.Register
        , Routing.onLinkClick (Parent (CommonMessages.ChangeLocation Routing.Register))
        , class "button"
        ]
        [ text "Zarejestruj"
        ]


view : Model -> Html Msg
view model =
    let
        content =
            case model.loginStatus of
                NotLoggedIn ->
                    [ loginPasswordForm model

                    -- , loginFacebookForm model
                    ]

                FacebookLoggedIn ->
                    [ logoutForm model ]

                PasswordLoggedIn ->
                    [ logoutForm model ]
    in
    section [ class "content" ] ([ h1 [] [ text "Zaloguj" ] ] ++ content)
