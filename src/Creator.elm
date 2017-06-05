module Creator exposing (Model, Msg, init, update, view)

import Accordion
import CreatorCanvas
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Input.Number


type Msg
    = ColorPicked String
    | LenghtChanged (Maybe Int)
    | ToggleColorPicker Accordion.Msg
    | ToggleLenghtPicker Accordion.Msg


type alias Model =
    { selectedColor : Maybe String
    , lenght : Maybe Int
    , colorPickerShown : Accordion.Model
    , lenghtPickerShown : Accordion.Model
    }


init : Model
init =
    { selectedColor = Nothing
    , lenght = Nothing
    , lenghtPickerShown = Accordion.init True
    , colorPickerShown = Accordion.init False
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg creator =
    case msg of
        ToggleColorPicker msg_ ->
            let
                ( accordion, message ) =
                    Accordion.update ToggleColorPicker msg_ creator.colorPickerShown
            in
            ( { creator | colorPickerShown = accordion }, message )

        ToggleLenghtPicker msg_ ->
            let
                ( accordion, message ) =
                    Accordion.update ToggleLenghtPicker msg_ creator.lenghtPickerShown
            in
            ( { creator | lenghtPickerShown = accordion }, message )

        ColorPicked val ->
            ( { creator | selectedColor = Just val }
            , Cmd.none
            )

        LenghtChanged val ->
            ( { creator | lenght = val }
            , Cmd.none
            )


colorPick : String -> Bool -> Html Msg
colorPick color selected =
    div
        [ onClick (ColorPicked color)
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
    [ "#F0AD00", "#F00D00", "#F0ADA0", "#40AD00", "#10AD40", "#306D21" ]


render : Model -> Bool
render model =
    (model.lenght /= Nothing) && (model.selectedColor /= Nothing)


colorPicker : Model -> Html Msg
colorPicker model =
    Accordion.view (text "Color")
        (div [ class "colorPicker" ]
            (List.map
                (\a -> colorPick a (Just a == model.selectedColor))
                colors
            )
        )
        ToggleColorPicker
        model.colorPickerShown


lenghtPicker : Model -> Html Msg
lenghtPicker model =
    Accordion.view (text "Lenght")
        (Input.Number.input
            { hasFocus = Nothing
            , maxLength = Just 3
            , maxValue = Just 150
            , minValue = Just 100
            , onInput = LenghtChanged
            }
            []
            model.lenght
        )
        ToggleLenghtPicker
        model.lenghtPickerShown


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [ class "controls" ]
            [ colorPicker model
            , lenghtPicker model
            ]
        , div [ class "canvas" ]
            (if render model then
                [ CreatorCanvas.creatorCanvas (Maybe.withDefault 100 model.lenght)
                    (Maybe.withDefault "" model.selectedColor)
                ]
             else
                []
            )
        ]
