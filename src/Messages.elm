module Messages exposing (..)

import Navigation


type Msg
    = ChangeLocation String
    | OnLocationChange Navigation.Location
    | BuyNowLoaded
