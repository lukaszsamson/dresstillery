module Messages exposing (..)

import Navigation


type CreatorMsg
    = ColorPicked String
    | LenghtChanged (Maybe Int)


type Msg
    = ChangeLocation String
    | OnLocationChange Navigation.Location
    | BuyNowLoaded
    | CreatorMessage CreatorMsg
