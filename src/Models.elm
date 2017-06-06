module Models exposing (..)

import Basket
import BuyNow
import Creator


type Route
    = Home
    | Creator
    | About
    | BuyNow
    | Basket
    | FabricsAndAccesories
    | TermsAndConditions
    | Contact
    | NotFound


type alias Model =
    { route : Route
    , menuShown : Bool
    , buyNow : BuyNow.Model
    , creator : Creator.Model
    , basket : Basket.Model
    }
