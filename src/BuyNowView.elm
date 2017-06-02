module BuyNowView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Models exposing (..)


item : String -> Html Msg
item label =
    div [] [ text label ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ if model.buyNow.loaded then
            div [] (List.map (\a -> item a.label) model.buyNow.items)
          else
            div [] [ text "Loading" ]
        ]
