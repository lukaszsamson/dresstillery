module ProductsApi exposing (..)

import Http
import Json.Decode exposing (Decoder, float, int, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import ProductModels exposing (..)
import RemoteData exposing (WebData)


get : String -> Decoder a -> (WebData a -> msg) -> Cmd msg
get url decoder msg =
    Http.get url decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


productsDecoder : Json.Decode.Decoder (List BuyNowItem)
productsDecoder =
    Json.Decode.list productDecoder


productDecoder : Json.Decode.Decoder BuyNowItem
productDecoder =
    decode BuyNowItem
        |> required "label" string
        |> required "src" string
        |> required "id" int


backend : String
backend =
    "http://localhost:4334"


fetchProducts : (WebData (List BuyNowItem) -> msg) -> Cmd msg
fetchProducts msg =
    get fetchProductsUrl productsDecoder msg


fetchProductsUrl : String
fetchProductsUrl =
    backend ++ "/products"


fetchProduct : Int -> (WebData BuyNowItem -> msg) -> Cmd msg
fetchProduct i msg =
    get (fetchProductUrl i) productDecoder msg


fetchProductUrl : Int -> String
fetchProductUrl i =
    backend ++ "/products/" ++ toString i
