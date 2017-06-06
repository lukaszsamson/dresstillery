module Models exposing (..)

import BuyNow
import Creator


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
    , menuShown : Bool
    , buyNow : BuyNow.Model
    , creator : Creator.Model
    , basket : Bool
    }
