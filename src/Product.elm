module Product exposing (..)

import BasketItem exposing (BasketItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ProductModels exposing (..)


type Msg
    = ToBasket BasketItem


type alias Model =
    BuyNowItem


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToBasket i ->
            model ! []


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [] [ img [ src model.src ] [] ]
        , div []
            [ text model.label
            ]
        , button [ onClick (ToBasket (BasketItem.CatalogItem { id = model.id })) ] [ text "Go" ]
        ]
