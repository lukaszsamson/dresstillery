module Main exposing (main)

import App exposing (update, view)
import Messages exposing (..)
import Models exposing (..)
import Navigation
import Routing exposing (..)


initialModel : Route -> Model
initialModel route =
    { route = route
    , changes = 0
    , buyNow =
        { loaded = False
        , items = []
        }
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
    ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
