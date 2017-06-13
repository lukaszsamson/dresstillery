module ProductsApi exposing (..)

import Api exposing (..)
import Json.Decode exposing (Decoder, andThen, fail, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import ProductModels exposing (..)
import RemoteData exposing (WebData)


productDecoder : Json.Decode.Decoder BuyNowItem
productDecoder =
    decode BuyNowItem
        |> required "label" string
        |> required "src" string
        |> required "id" int
        |> required "price" float
        |> required "lenghts"
            (list
                (string
                    |> andThen lenghtDecoder
                )
            )


lenghtDecoder : String -> Decoder Lenght
lenghtDecoder val =
    case val of
        "midi" ->
            succeed Midi

        "mini" ->
            succeed Mini

        _ ->
            fail ("Unknown value: " ++ val)


fetchProducts : (WebData (List BuyNowItem) -> msg) -> Cmd msg
fetchProducts msg =
    get (backend ++ "/products") (list productDecoder) msg


fetchProduct : Int -> (WebData BuyNowItem -> msg) -> Cmd msg
fetchProduct i msg =
    get (backend ++ "/products/" ++ toString i) productDecoder msg
