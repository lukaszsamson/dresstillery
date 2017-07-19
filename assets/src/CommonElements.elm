module CommonElements exposing (..)

import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ProductModels
import Utils


icon : (Color -> number -> Html msg) -> Html msg
icon ico =
    div [ class "icon" ]
        [ ico (Color.rgb 0 0 0) 60
        ]


toBasketButton : Bool -> msg -> Html msg
toBasketButton justAdded msg =
    if justAdded then
        span [ class "button" ] [ text "Dodano" ]
    else
        button [ onClick msg ] [ text "Do koszyka" ]


toBasketButtonAfter : a -> Cmd a
toBasketButtonAfter msg =
    Utils.delay 1000 msg


lenghtPicker : List ProductModels.Lenght -> Maybe ProductModels.Lenght -> (ProductModels.Lenght -> msg) -> Html msg
lenghtPicker lenghts selectedLenght msg =
    div [ class "lenghtPicker" ]
        (lenghts
            |> List.map
                (\a ->
                    Html.label
                        [ class
                            (if selectedLenght == Just a then
                                "radioChecked"
                             else
                                ""
                            )
                        ]
                        [ input [ type_ "radio", name "lenghtPicker", onClick (msg a) ] []
                        , text (toString a)
                        ]
                )
        )
