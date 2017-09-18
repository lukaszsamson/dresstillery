module FabricsApi exposing (..)

import Api exposing (..)
import FabricModels exposing (..)
import Json.Decode exposing (Decoder, andThen, fail, field, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (..)
import RemoteData exposing (WebData)


ingridientDecoder : Json.Decode.Decoder Ingridient
ingridientDecoder =
    decode Ingridient
        |> required "name" string
        |> required "percentage" int


fabricDecoder : Json.Decode.Decoder FabricsItem
fabricDecoder =
    decode FabricsItem
        |> required "name" string
        |> required "code" string
        |> required "description" string
        |> required "images" (list string)
        |> required "id" int
        |> required "ingridients"
            (list ingridientDecoder)


fetchFabrics : Flags -> (WebData (List FabricsItem) -> msg) -> Cmd msg
fetchFabrics flags msg =
    get (flags.backendUrl ++ "/fabrics") (field "data" (list fabricDecoder)) msg


fetchFabric : Flags -> Int -> (WebData FabricsItem -> msg) -> Cmd msg
fetchFabric flags i msg =
    get (flags.backendUrl ++ "/fabrics/" ++ toString i) (field "data" fabricDecoder) msg
