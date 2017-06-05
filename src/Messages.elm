module Messages exposing (..)

import Creator
import Navigation


type Msg
    = ChangeLocation String
    | OnLocationChange Navigation.Location
    | ToggleMenu
    | BuyNowLoaded
    | CreatorMessage Creator.Msg
