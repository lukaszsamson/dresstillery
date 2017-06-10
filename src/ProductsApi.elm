module ProductsApi exposing (..)

import Api exposing (..)
import Json.Decode exposing (Decoder, float, int, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import ProductModels exposing (..)
import RemoteData exposing (WebData)


productDecoder : Json.Decode.Decoder BuyNowItem
productDecoder =
    decode BuyNowItem
        |> required "label" string
        |> required "src" string
        |> required "id" int


fetchProducts : (WebData (List BuyNowItem) -> msg) -> Cmd msg
fetchProducts msg =
    get (backend ++ "/products") (Json.Decode.list productDecoder) msg


fetchProduct : Int -> (WebData BuyNowItem -> msg) -> Cmd msg
fetchProduct i msg =
    get (backend ++ "/products/" ++ toString i) productDecoder msg
