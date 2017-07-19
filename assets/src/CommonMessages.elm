module CommonMessages exposing (..)

import BasketItem exposing (..)
import Routing exposing (Route)


type Msg
    = ToBasket BasketItem
    | ChangeLocation Route
