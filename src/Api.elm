module Api exposing (..)

import Http
import Json.Decode exposing (Decoder, float, int, string)
import RemoteData exposing (WebData)


get : String -> Decoder a -> (WebData a -> msg) -> Cmd msg
get url decoder msg =
    Http.get url decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


backend : String
backend =
    "http://localhost:4334"
