port module User.User exposing (..)

import Api exposing (ApiError, handleFailure)
import CommonMessages
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)
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
    | FacebookNotLoggedInResult String
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
    | LoggingOut


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
    { login = ""
    , password = ""
    , loginPasswordResponse = RemoteData.NotAsked
    , loginFacebookResponse = RemoteData.NotAsked
    , loginStatus = NotLoggedIn
    , flags = flags
    }



-- PORTS


port facebookLoggedIn : (String -> msg) -> Sub msg


port facebookNotLoggedIn : (String -> msg) -> Sub msg


port facebookLogin : {} -> Cmd msg


port facebookLogout : {} -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ facebookLoggedIn FacebookLoggedInResult
        , facebookNotLoggedIn FacebookNotLoggedInResult
        ]


updateLoginStatus : RemoteData.RemoteData e a -> LoginStatus -> LoginStatus -> LoginStatus
updateLoginStatus result current wanted =
    case result of
        RemoteData.Success _ ->
            wanted

        _ ->
            current


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
            in
            ( { model | loginStatus = loginStatus, loginPasswordResponse = response }, Cmd.none )

        LoginFacebookResponse response ->
            let
                _ =
                    Debug.log "update LoggedIn " "LoginFacebookResponse"

                loginStatus =
                    updateLoginStatus response model.loginStatus FacebookLoggedIn
            in
            ( { model | loginStatus = loginStatus, loginFacebookResponse = response }, Cmd.none )

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

        FacebookNotLoggedInResult loggedOutMsg ->
            case model.loginStatus of
                LoggingOut ->
                    ( { model | loginStatus = NotLoggedIn }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Logout ->
            let
                _ =
                    Debug.log "logout " model.loginStatus
            in
            case model.loginStatus of
                NotLoggedIn ->
                    ( model, Cmd.none )

                LoggingOut ->
                    ( model, Cmd.none )

                FacebookLoggedIn ->
                    ( { model | loginStatus = LoggingOut }, facebookLogout {} )

                PasswordLoggedIn ->
                    -- TODO
                    ( model, Cmd.none )

        Parent msg_ ->
            ( model, Cmd.none )


formError : ApiError -> String -> Html msg
formError error field =
    Html.div [ class "form-error" ]
        (error |> Dict.get field |> Maybe.withDefault [] |> List.map text)


loginPasswordForm : Model -> Html Msg
loginPasswordForm model =
    let
        error =
            model.loginPasswordResponse |> handleFailure
    in
    Html.form [ onSubmit (LoginPassword model.login model.password) ]
        [ Html.label []
            [ text "Login"
            , input [ value model.login, onInput LoginFieldChanged ] []
            , formError error "login"
            ]
        , Html.label [ type_ "password" ]
            [ text "Hasło"
            , input [ value model.password, onInput PasswordFieldChanged ] []
            , formError error "password"
            ]
        , formError error "_"
        , Html.button [ type_ "submit" ] [ text "Zaloguj" ]
        ]


loginFacebookForm : Model -> Html Msg
loginFacebookForm model =
    let
        error =
            model.loginFacebookResponse |> handleFailure
    in
    Html.form [ onSubmit LoginFacebook ]
        [ Html.button [ type_ "submit" ] [ text "Zaloguj przez Facebook" ]
        , formError error "_"
        ]


logoutForm : Model -> Html Msg
logoutForm model =
    Html.form [ onSubmit Logout ]
        [ Html.button [ type_ "submit" ] [ text "Wyloguj" ] ]


view : Model -> Html Msg
view model =
    let
        content =
            case model.loginStatus of
                NotLoggedIn ->
                    [ loginPasswordForm model
                    , loginFacebookForm model
                    ]

                FacebookLoggedIn ->
                    [ logoutForm model ]

                PasswordLoggedIn ->
                    [ logoutForm model ]

                LoggingOut ->
                    []
    in
    section [ class "content" ] content
