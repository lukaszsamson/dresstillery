module Accordion exposing (Model, Msg, init, update, view)

import Color
import FontAwesome
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time
import Utils exposing (delay)


type alias Model =
    Maybe Bool


type Msg
    = StartChange
    | FinishChange Bool


init : Bool -> Model
init v =
    Just v


accordionBodyClass : Maybe Bool -> String
accordionBodyClass shown =
    case shown of
        Nothing ->
            "showing"

        Just True ->
            ""

        Just False ->
            "hidden"


icon : Model -> Html msg
icon shown =
    (case shown of
        Just True ->
            FontAwesome.chevron_up

        _ ->
            FontAwesome.chevron_down
    )
        (Color.rgb 0 0 0)
        15


view : Html msg -> Html msg -> (Msg -> msg) -> Model -> Html msg
view header body pack shown =
    div [ class "accordion" ]
        [ div [ class "accordionHeader", onClick (pack StartChange) ]
            [ header
            , div [ class "accordionHeaderIcon" ]
                [ icon shown
                ]
            ]
        , div
            [ class "accordionBody"
            , class
                (accordionBodyClass shown)
            ]
            [ body ]
        ]


update : (Msg -> msg) -> Msg -> Model -> ( Model, Cmd msg )
update pack msg shown =
    case msg of
        StartChange ->
            case shown of
                Nothing ->
                    shown ! []

                Just s ->
                    Nothing ! [ delay (Time.second * 0.3) <| pack <| FinishChange (not s) ]

        FinishChange v ->
            Just v ! []
