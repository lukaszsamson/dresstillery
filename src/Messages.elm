module Messages exposing (..)

import BuyNow
import Creator
import Navigation


type Msg
    = ChangeLocation String
    | OnLocationChange Navigation.Location
    | ToggleMenu
    | BuyNowMessage BuyNow.Msg
    | CreatorMessage Creator.Msg
