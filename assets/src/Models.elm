module Models exposing (..)


type alias InitialState =
    { token : Maybe String
    , loginType : Maybe String
    }


type alias Flags =
    { backendUrl : String
    , o_mnie : String
    , home_witamy : String
    , aktualna_kolekcja : String
    , galeria_tkanin : String
    , otworz_konfigurator : String
    , initialState : InitialState
    }
