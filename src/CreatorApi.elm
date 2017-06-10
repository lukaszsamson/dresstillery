module CreatorApi exposing (..)

import Api exposing (..)
import CreatorModels exposing (..)
import Json.Decode exposing (Decoder, float, int, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import RemoteData exposing (WebData)


fabricDecoder : Json.Decode.Decoder Fabric
fabricDecoder =
    decode Fabric
        |> required "label" string
        |> required "color" string
        |> required "id" int


fetchFabrics : (WebData (List Fabric) -> msg) -> Cmd msg
fetchFabrics msg =
    get (backend ++ "/fabrics") (Json.Decode.list fabricDecoder) msg


lenghtDecoder : Json.Decode.Decoder Length
lenghtDecoder =
    decode Length
        |> required "label" string
        |> required "value" int


fetchLenghts : (WebData (List Length) -> msg) -> Cmd msg
fetchLenghts msg =
    get (backend ++ "/lenghts") (Json.Decode.list lenghtDecoder) msg
