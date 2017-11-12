module User.Fb exposing (..)

import Json.Decode as Decode exposing (decodeString)
import User.Decoder exposing (..)
import User.Model as User exposing (..)


-- MESSAGES


type Msg
    = LoggedIn String
    | LoggedOut String



-- UPDATE


update : Msg -> User.Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoggedIn json ->
            let
                _ =
                    Debug.log "User.update UserLoggedIn " (decodeString userDecoder json)
            in
            case decodeString userDecoder json of
                Ok userData ->
                    ( { model
                        | uid = userData.uid
                        , name = userData.name
                        , url = userData.url
                        , loginStatus = Connected
                      }
                    , Cmd.none
                    )

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                    ( model, Cmd.none )

        LoggedOut loggedOut ->
            ( init, Cmd.none )
