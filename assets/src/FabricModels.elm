module FabricModels exposing (..)


type alias Ingridient =
    { name : String
    , percentage : Int
    }


type alias FabricsItem =
    { name : String
    , code : String
    , description : String
    , images : List String
    , id : Int
    , ingridients : List Ingridient
    }
