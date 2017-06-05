module Models exposing (..)

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


type alias BuyNowItem =
    { label : String
    , src : String
    }


type alias BuyNowModel =
    { loaded : Bool
    , items : List BuyNowItem
    }


type alias Model =
    { route : Route
    , menuShown : Bool
    , buyNow : BuyNowModel
    , creator : Creator.Model
    }
