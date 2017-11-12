module Api exposing (..)

import Dict exposing (Dict)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, float, int, string)
import Json.Encode as Encode exposing (..)
import RemoteData exposing (WebData)


get : String -> Decoder a -> (WebData a -> msg) -> Cmd msg
get url decoder msg =
    Http.get url decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


post : String -> Encode.Value -> Decoder a -> (WebData a -> msg) -> Cmd msg
post url json decoder msg =
    let
        body =
            json |> Http.jsonBody
    in
    Http.post url body decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


type alias ApiError =
    Dict String (List String)


type ApiErrorNode
    = DictNode (Dict String ApiErrorNode)
    | ListNode (List String)


errorNodeDecoder : Decoder ApiErrorNode
errorNodeDecoder =
    Decode.oneOf
        [ Decode.dict (Decode.lazy (\_ -> errorNodeDecoder)) |> Decode.map DictNode
        , Decode.list Decode.string |> Decode.map ListNode
        ]


flatten :
    ApiErrorNode
    -> String
    -> Dict String (List String)
    -> Dict String (List String)
flatten d key acc =
    case d of
        ListNode list ->
            acc |> Dict.insert key list

        DictNode dict ->
            dict
                |> Dict.foldl
                    (\k v a ->
                        let
                            key_ =
                                if key == "_" then
                                    k
                                else
                                    key ++ "." ++ k
                        in
                        flatten v key_ a
                    )
                    acc


errorDecoder : Decoder (Dict String (List String))
errorDecoder =
    Decode.field "errors" errorNodeDecoder
        |> Decode.map (\v -> flatten v "_" Dict.empty)


buildError : String -> ApiError
buildError e =
    [ ( "_", [ e ] ) ] |> Dict.fromList


handleBadStatus : Http.Response String -> ApiError
handleBadStatus response =
    case response.status.code of
        422 ->
            case Decode.decodeString errorDecoder response.body of
                Ok error ->
                    error

                Err e ->
                    Debug.crash (toString response)

        503 ->
            buildError "Tymczasowy problem, spróbuj ponownie"

        _ ->
            Debug.crash (toString response)


checkConnectionAndTryAgain : String
checkConnectionAndTryAgain =
    "Sprawdź swoje połączenie internetowe i spróbuj ponownie."


handleError : Http.Error -> ApiError
handleError error =
    case error of
        Http.BadStatus response ->
            handleBadStatus response

        Http.Timeout ->
            buildError <| "Serwer nie odpowiada. " ++ checkConnectionAndTryAgain

        Http.NetworkError ->
            buildError <| "Nie można połączyć się z serwerem. " ++ checkConnectionAndTryAgain

        Http.BadUrl url ->
            Debug.crash (toString error)

        Http.BadPayload message response ->
            Debug.crash (toString error)


handleFailure : RemoteData.RemoteData Http.Error a -> ApiError
handleFailure response =
    case response of
        RemoteData.Failure e ->
            handleError e

        _ ->
            Dict.empty
