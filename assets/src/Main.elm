module Main exposing (main)

import App exposing (..)
import Models exposing (..)
import Navigation


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
