module ProductModels exposing (..)

import FabricModels


type Lenght
    = Mini
    | Midi


type alias Part =
    { name : String
    , ingridients : List FabricModels.Ingridient
    }


type alias ProductsItem =
    { name : String
    , code : String
    , shortDescription : String
    , mainDescription : String
    , specificDescription : String
    , images : List String
    , id : Int
    , price : Float
    , lenght : Int
    , parts : List Part
    }
