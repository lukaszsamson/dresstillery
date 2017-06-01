module Models exposing (..)


type Route
    = HomeRoute
    | CreatorRoute
    | NotFoundRoute


type alias Model =
    { route : Route
    , changes : Int
    }
