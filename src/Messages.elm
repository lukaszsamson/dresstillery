module Messages exposing (..)

import Basket
import BuyNow
import Creator
import Navigation
import Product
import Routing


type Msg
    = ChangeLocation Routing.Route
    | OnLocationChange Navigation.Location
    | ToggleMenu
    | BuyNowMessage BuyNow.Msg
    | ProductMessage Product.Msg Int
    | CreatorMessage Creator.Msg
    | BasketMessage Basket.Msg
