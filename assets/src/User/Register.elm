port module User.Register exposing (..)

import Api exposing (ApiError, handleFailure)
import CommonElements exposing (formError)
import CommonMessages
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)
import User.Api exposing (LoginResponse, register)


type Msg
    = Register String String
    | RegisterResponse (WebData LoginResponse)
    | LoginFieldChanged String
    | PasswordFieldChanged String
    | PasswordRepeatFieldChanged String
    | Parent CommonMessages.Msg


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


type alias Model =
    { login : String
    , password : String
    , passwordRepeat : String
    , registerResponse : WebData LoginResponse
    , flags : Flags
    }


init : Flags -> Model
init flags =
    { login = ""
    , password = ""
    , passwordRepeat = ""
    , registerResponse = RemoteData.NotAsked
    , flags = flags
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Register login password ->
            ( model, register model.flags model.login model.password RegisterResponse )

        RegisterResponse response ->
            ( { model | registerResponse = response }, Cmd.none )

        LoginFieldChanged value ->
            ( { model | login = value }, Cmd.none )

        PasswordFieldChanged value ->
            ( { model | password = value }, Cmd.none )

        PasswordRepeatFieldChanged value ->
            ( { model | passwordRepeat = value }, Cmd.none )

        Parent msg_ ->
            ( model, Cmd.none )


registerForm : Model -> Html Msg
registerForm model =
    let
        error =
            model.registerResponse |> handleFailure

        _ =
            Debug.log "error" (toString error)
    in
    Html.form [ onSubmit (Register model.login model.password) ]
        [ Html.label []
            [ text "Login"
            , input [ value model.login, onInput LoginFieldChanged ] []
            , formError error "password_authentication.login"
            ]
        , Html.label []
            [ text "Hasło"
            , input [ type_ "password", value model.password, onInput PasswordFieldChanged ] []
            , formError error "password_authentication.password"
            ]
        , Html.label []
            [ text "Powtórz hasło"
            , input [ type_ "password", value model.passwordRepeat, onInput PasswordRepeatFieldChanged ] []
            , formError error "password_authentication.passwordRepeat"
            ]
        , formError error "_"
        , Html.button [ type_ "submit" ] [ text "Zarejestruj" ]
        ]


view : Model -> Html Msg
view model =
    section [ class "content" ] [ registerForm model ]
