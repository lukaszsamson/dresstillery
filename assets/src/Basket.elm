module Basket exposing (..)

import Array exposing (Array)
import BasketItem exposing (BasketItem)
import CommonMessages
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed
import Routing exposing (Route, linkHref, onLinkClick)


type Msg
    = AddLine BasketItem
    | LineMessage Int BasketLineMsg
    | Parent CommonMessages.Msg


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


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
        Parent _ ->
            model ! []

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


itemLink : BasketItem -> Html Msg
itemLink item =
    case item of
        BasketItem.CatalogItem item_ ->
            let
                route =
                    Routing.Product item_.item.id
            in
            a [ linkHref route, onLinkClick (changeLocation route) ] [ text "Otwórz" ]

        BasketItem.CustomItem item_ ->
            -- TODO load model in creator
            a [ linkHref Routing.Creator, onLinkClick (changeLocation Routing.Creator) ] [ text "Otwórz" ]


changeLocation : Route -> Msg
changeLocation r =
    Parent <| CommonMessages.ChangeLocation r


itemLabel : BasketItem -> Html Msg
itemLabel item =
    case item of
        BasketItem.CatalogItem item_ ->
            text (item_.item.name ++ ", " ++ toString item_.lenght)

        BasketItem.CustomItem item_ ->
            text "custom item"


item : Int -> BasketLine -> Html Msg
item i item =
    li [ class "basketListItem" ]
        (if item.removalPending then
            [ div [] [ text "Czy na pewno chcesz usunąć tą pozycję?" ]
            , button [ onClick (LineMessage i ConfirmRemove) ] [ text "Tak" ]
            , button [ onClick (LineMessage i CancelRemove) ] [ text "Nie" ]
            ]
         else
            [ div [] [ itemLabel item.item ]
            , itemLink item.item
            , div [ class "basketLineQuantity" ]
                [ button [ onClick (LineMessage i (ChangeQuantity 1)) ] [ text "+" ]
                , div [ class "numberBox" ] [ text (item.quantity |> toString) ]
                , button [ onClick (LineMessage i (ChangeQuantity -1)) ] [ text "-" ]
                ]
            , button [ onClick (LineMessage i Remove) ] [ text "x" ]
            ]
        )


view : Model -> Html Msg
view model =
    let
        items =
            model.items |> Array.indexedMap (\i a -> ( toString i, item i a )) |> Array.toList
    in
    section [ class "content" ]
        ([ h1 [] [ text "Koszyk" ] ]
            ++ (if Array.isEmpty model.items then
                    [ div [ class "simpleMessage" ] [ text "Twój koszyk jest pusty." ] ]
                else
                    []
               )
            ++ [ Html.Keyed.ul [ class "basketItems" ] items ]
        )
