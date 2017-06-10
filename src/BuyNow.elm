module BuyNow exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)
import Routing exposing (Route, linkHref, onLinkClick)


type Msg
    = Load
    | ChangeLocation Route
    | Loaded (WebData (List BuyNowItem))


type alias Model =
    { items : WebData (List BuyNowItem)
    }


init : Model
init =
    { items = RemoteData.NotAsked
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Load ->
        --     ( model
        --     , if not model.loaded then
        --         delay (Time.second * 1) <| Loaded <| []
        --       else
        --         Cmd.none
        --     )
        Load ->
            ( { model | items = RemoteData.Loading }, ProductsApi.fetchProducts Loaded )

        Loaded response ->
            ( { model | items = response }, Cmd.none )

        ChangeLocation _ ->
            model ! []


item : BuyNowItem -> Html Msg
item item =
    let
        route =
            Routing.Product item.id
    in
    div [ class "buyNowItem" ]
        [ a [ linkHref route, onLinkClick (ChangeLocation route) ] [ img [ src item.src ] [] ]
        , div []
            [ text item.label
            ]
        ]


maybeList : WebData (List BuyNowItem) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success items ->
            div [] (List.map item items)

        RemoteData.Failure error ->
            text (toString error)


view : Model -> Html Msg
view model =
    div [ class "content", class "grid3" ]
        [ maybeList model.items ]
