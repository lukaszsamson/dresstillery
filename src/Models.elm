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


type alias BuyNowItem =
    { label : String
    , src : String
    }


type alias BuyNowModel =
    { loaded : Bool
    , items : List BuyNowItem
    }


type alias CreatorModel =
    { selectedColor : Maybe String
    , lenght : Maybe Int
    }


type alias Model =
    { route : Route
    , menuShown : Bool
    , buyNow : BuyNowModel
    , creator : CreatorModel
    }
