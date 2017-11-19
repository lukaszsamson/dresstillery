module User.Api exposing (..)

import Api exposing (..)
import Json.Decode as Decode exposing (Decoder, andThen, bool, fail, field, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Json.Encode as Encode exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)


type alias LoginResponse =
    { id : Int
    , token : String
    }


loginResponseDecoder : Decode.Decoder LoginResponse
loginResponseDecoder =
    decode LoginResponse
        |> required "id" Decode.int
        |> required "token" Decode.string


loginFacebookEncode : String -> Value
loginFacebookEncode token =
    Encode.object
        [ ( "token", Encode.string token )
        ]


loginPasswordEncode : String -> String -> Value
loginPasswordEncode login password =
    Encode.object
        [ ( "login", Encode.string login )
        , ( "password", Encode.string password )
        ]


loginFacebook : Flags -> String -> (WebData LoginResponse -> msg) -> Cmd msg
loginFacebook flags token msg =
    post (flags.backendUrl ++ "/account/login_facebook") (loginFacebookEncode token) (field "data" loginResponseDecoder) msg


loginPassword : Flags -> String -> String -> (WebData LoginResponse -> msg) -> Cmd msg
loginPassword flags login password msg =
    post (flags.backendUrl ++ "/account/login") (loginPasswordEncode login password) (field "data" loginResponseDecoder) msg


register : Flags -> String -> String -> (WebData LoginResponse -> msg) -> Cmd msg
register flags login password msg =
    post (flags.backendUrl ++ "/account/register") (loginPasswordEncode login password) (field "data" loginResponseDecoder) msg
