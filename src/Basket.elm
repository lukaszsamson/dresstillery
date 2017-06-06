module Basket exposing (..)

import Array exposing (Array)
import BasketItem exposing (BasketItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = AddLine BasketItem
    | LineMessage Int BasketLineMsg


type BasketLineMsg
    = ConfirmRemove
    | CancelRemove
    | Remove
    | ChangeQuantity Int


type alias BasketLine =
    { quantity : Int
    , item : BasketItem
    , removalPending : Bool
    }


type alias Model =
    { items : Array BasketLine }


init : Model
init =
    { items = Array.empty }


updateItem : BasketLineMsg -> BasketLine -> BasketLine
updateItem message item =
    case message of
        ChangeQuantity change ->
            let
                updatedQuantity =
                    item.quantity + change
            in
            if updatedQuantity == 0 then
                { item | removalPending = True }
            else
                { item | quantity = updatedQuantity }

        ConfirmRemove ->
            { item | quantity = 0 }

        CancelRemove ->
            { item | removalPending = False }

        Remove ->
            updateItem (ChangeQuantity -item.quantity) item


updateLines : Int -> Array BasketLine -> BasketLineMsg -> Array BasketLine
updateLines v items change =
    Array.get v items
        |> Maybe.map (updateItem change)
        |> Maybe.map (\item -> Array.set v item items)
        |> Maybe.withDefault items
        |> Array.filter (\item -> item.quantity > 0)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddLine item ->
            let
                updatedItems =
                    Array.push { quantity = 1, item = item, removalPending = False } model.items
            in
            { model | items = updatedItems } ! []

        LineMessage v msg_ ->
            let
                updatedItems =
                    updateLines v model.items msg_
            in
            { model | items = updatedItems } ! []


item : Int -> BasketLine -> Html Msg
item i item =
    div []
        (if item.removalPending then
            [ div [] [ text "R U Sure" ]
            , button [ onClick (LineMessage i ConfirmRemove) ] [ text "Yes" ]
            , button [ onClick (LineMessage i CancelRemove) ] [ text "No" ]
            ]
         else
            [ div [] [ text (toString item.item) ]
            , button [ onClick (LineMessage i (ChangeQuantity 1)) ] [ text "+" ]
            , div [] [ text (item.quantity |> toString) ]
            , button [ onClick (LineMessage i (ChangeQuantity -1)) ] [ text "-" ]
            , button [ onClick (LineMessage i Remove) ] [ text "x" ]
            ]
        )


view : Model -> Html Msg
view model =
    div [ class "content" ]
        (model.items |> Array.indexedMap item |> Array.toList)
