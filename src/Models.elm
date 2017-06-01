module Models exposing (..)


type Route
    = Home
    | Creator
    | About
    | BuyNow
    | FabricsAndAccesories
    | TermsAndConditions
    | Contact
    | NotFound


type alias Model =
    { route : Route
    , changes : Int
    }
