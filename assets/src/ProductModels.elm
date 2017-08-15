module ProductModels exposing (..)


type Lenght
    = Mini
    | Midi


type alias Ingridient =
    { name : String
    , percentage : Int
    }


type alias Part =
    { name : String
    , ingridients : List Ingridient
    }


type alias BuyNowItem =
    { name : String
    , images : List String
    , id : Int
    , price : Float
    , lenght : Int
    , parts : List Part
    }
