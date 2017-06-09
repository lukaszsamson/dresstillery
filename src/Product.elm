module Product exposing (..)

import BasketItem exposing (BasketItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)


type Msg
    = ToBasket BasketItem
    | Load
    | Loaded (WebData BuyNowItem)


type alias Model =
    { product : WebData BuyNowItem
    , id : Int
    }


init : Int -> Model
init i =
    { id = i
    , product = RemoteData.NotAsked
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToBasket i ->
            model ! []

        Load ->
            ( { model | product = RemoteData.Loading }, ProductsApi.fetchProduct model.id Loaded )

        Loaded response ->
            ( { model | product = response }, Cmd.none )


maybeProduct : WebData BuyNowItem -> Html Msg
maybeProduct response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success model ->
            div []
                [ div [] [ img [ src model.src ] [] ]
                , div []
                    [ text model.label
                    ]
                , button [ onClick (ToBasket (BasketItem.CatalogItem { id = model.id })) ] [ text "Go" ]
                ]

        RemoteData.Failure error ->
            text (toString error)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ maybeProduct model.product
        ]
