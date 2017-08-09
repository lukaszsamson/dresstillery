module ProductsApi exposing (..)

import Api exposing (..)
import Json.Decode exposing (Decoder, andThen, fail, field, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (..)
import ProductModels exposing (..)
import RemoteData exposing (WebData)


ingridientDecoder : Json.Decode.Decoder Ingridient
ingridientDecoder =
    decode Ingridient
        |> required "name" string
        |> required "percentage" int


productDecoder : Json.Decode.Decoder BuyNowItem
productDecoder =
    decode BuyNowItem
        |> required "label" string
        |> required "images" (list string)
        |> required "id" int
        |> required "price" float
        |> required "lenghts"
            (list
                (string
                    |> andThen lenghtDecoder
                )
            )
        |> required "ingridients"
            (list ingridientDecoder)


lenghtDecoder : String -> Decoder Lenght
lenghtDecoder val =
    case val of
        "midi" ->
            succeed Midi

        "mini" ->
            succeed Mini

        _ ->
            fail ("Unknown value: " ++ val)


fetchProducts : Flags -> (WebData (List BuyNowItem) -> msg) -> Cmd msg
fetchProducts flags msg =
    get (flags.backendUrl ++ "/products") (field "data" (list productDecoder)) msg


fetchProduct : Flags -> Int -> (WebData BuyNowItem -> msg) -> Cmd msg
fetchProduct flags i msg =
    get (flags.backendUrl ++ "/products/" ++ toString i) (field "data" productDecoder) msg
