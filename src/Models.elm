module Models exposing (..)

import Basket
import BuyNow
import Creator
import Dict exposing (Dict)
import Product
import Routing exposing (Route)


type alias Model =
    { route : Route
    , menuShown : Bool
    , buyNow : BuyNow.Model
    , creator : Creator.Model
    , basket : Basket.Model
    , products : Dict Int Product.Model
    }
