module Main exposing (main)

import App exposing (init, subscriptions, update, view)
import Messages exposing (..)
import Models exposing (..)
import Navigation


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
