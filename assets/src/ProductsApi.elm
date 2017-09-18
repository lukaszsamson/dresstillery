module ProductsApi exposing (..)

import Api exposing (..)
import FabricsApi
import Json.Decode exposing (Decoder, andThen, fail, field, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Models exposing (..)
import ProductModels exposing (..)
import RemoteData exposing (WebData)


partDecoder : Json.Decode.Decoder Part
partDecoder =
    decode Part
        |> required "name" string
        |> required "ingridients" (list FabricsApi.ingridientDecoder)


productDecoder : Json.Decode.Decoder ProductsItem
productDecoder =
    decode ProductsItem
        |> required "name" string
        |> required "code" string
        |> required "short_description" string
        |> required "main_description" string
        |> required "specific_description" string
        |> required "images" (list string)
        |> required "id" int
        |> required "price" float
        |> required "lenght" int
        |> required "parts"
            (list partDecoder)



-- lenghtDecoder : String -> Decoder Lenght
-- lenghtDecoder val =
--     case val of
--         "midi" ->
--             succeed Midi
--
--         "mini" ->
--             succeed Mini
--
--         _ ->
--             fail ("Unknown value: " ++ val)


fetchProducts : Flags -> (WebData (List ProductsItem) -> msg) -> Cmd msg
fetchProducts flags msg =
    get (flags.backendUrl ++ "/products") (field "data" (list productDecoder)) msg


fetchProduct : Flags -> Int -> (WebData ProductsItem -> msg) -> Cmd msg
fetchProduct flags i msg =
    get (flags.backendUrl ++ "/products/" ++ toString i) (field "data" productDecoder) msg
