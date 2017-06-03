module BuyNowView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Models exposing (..)


item : BuyNowItem -> Html Msg
item item =
    div []
        [ div [] [ img [ src item.src ] [] ]
        , div []
            [ text item.label
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ if model.buyNow.loaded then
            div [] (List.map item model.buyNow.items)
          else
            div [] [ text "Loading" ]
        ]
