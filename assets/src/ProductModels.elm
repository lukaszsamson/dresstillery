module ProductModels exposing (..)


type Lenght
    = Mini
    | Midi


type alias Ingridient =
    { name : String
    , percentage : Int
    }


type alias BuyNowItem =
    { label : String
    , src : String
    , id : Int
    , price : Float
    , lenghts : List Lenght
    , ingridients : List Ingridient
    }
