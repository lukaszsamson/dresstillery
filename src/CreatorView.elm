module CreatorView exposing (..)

import CreatorCanvas
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Input.Number
import Messages exposing (..)
import Models exposing (..)


colorPick : String -> Bool -> Html Msg
colorPick color selected =
    div
        [ onClick (CreatorMessage (ColorPicked color))
        , class
            (if selected then
                "selected"
             else
                ""
            )
        , class "colorPick"
        , style
            [ ( "background-color", color )
            ]
        ]
        [ text color ]


colors : List String
colors =
    [ "#F0AD00", "#F00D00", "#F0ADA0", "#40AD00", "#10AD40", "#306D20" ]


render : Model -> Bool
render model =
    (model.creator.lenght /= Nothing) && (model.creator.selectedColor /= Nothing)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [ class "controls" ]
            [ div [ class "colorPicker" ]
                (List.map
                    (\a -> colorPick a (Just a == model.creator.selectedColor))
                    colors
                )
            , Input.Number.input
                { hasFocus = Nothing
                , maxLength = Just 3
                , maxValue = Just 150
                , minValue = Just 100
                , onInput = \a -> CreatorMessage (LenghtChanged a)
                }
                []
                model.creator.lenght
            ]
        , div [ class "canvas" ]
            (if render model then
                [ CreatorCanvas.creatorCanvas (Maybe.withDefault 100 model.creator.lenght)
                    (Maybe.withDefault "" model.creator.selectedColor)
                ]
             else
                []
            )
        ]
