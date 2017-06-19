module Creator exposing (..)

import Accordion
import BasketItem exposing (BasketItem)
import CreatorApi
import CreatorCanvas
import CreatorModels exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import RemoteData exposing (WebData)


type Msg
    = ColorPicked String
    | ToBasket BasketItem
    | LenghtChanged Int
    | ToggleColorPicker Accordion.Msg
    | ToggleLenghtPicker Accordion.Msg
    | Load
    | FabricsLoaded (WebData (List Fabric))
    | LenghtsLoaded (WebData (List Length))


type alias Model =
    { selectedColor : Maybe String
    , lenght : Maybe Int
    , colorPickerShown : Accordion.Model
    , lenghtPickerShown : Accordion.Model
    , fabrics : WebData (List Fabric)
    , lenghts : WebData (List Length)
    , flags : Flags
    }


init : Flags -> Model
init flags =
    { selectedColor = Nothing
    , lenght = Nothing
    , lenghtPickerShown = Accordion.init True
    , colorPickerShown = Accordion.init False
    , fabrics = RemoteData.NotAsked
    , lenghts = RemoteData.NotAsked
    , flags = flags
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            { model | fabrics = RemoteData.Loading } ! [ CreatorApi.fetchFabrics model.flags FabricsLoaded, CreatorApi.fetchLenghts model.flags LenghtsLoaded ]

        FabricsLoaded response ->
            ( { model | fabrics = response }, Cmd.none )

        LenghtsLoaded response ->
            ( { model | lenghts = response }, Cmd.none )

        ToggleColorPicker msg_ ->
            let
                ( accordion, message ) =
                    Accordion.update ToggleColorPicker msg_ model.colorPickerShown
            in
            ( { model | colorPickerShown = accordion }, message )

        ToggleLenghtPicker msg_ ->
            let
                ( accordion, message ) =
                    Accordion.update ToggleLenghtPicker msg_ model.lenghtPickerShown
            in
            ( { model | lenghtPickerShown = accordion }, message )

        ColorPicked val ->
            ( { model | selectedColor = Just val }
            , Cmd.none
            )

        LenghtChanged val ->
            ( { model | lenght = Just val }
            , Cmd.none
            )

        ToBasket _ ->
            model ! []


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


render : Model -> Bool
render model =
    (model.lenght /= Nothing) && (model.selectedColor /= Nothing)


maybeRemoteData : (a -> Html msg) -> RemoteData.RemoteData b a -> Html msg
maybeRemoteData view data =
    case data of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success loadedData ->
            view loadedData

        RemoteData.Failure error ->
            text (toString error)


colorPicker : Model -> Html Msg
colorPicker model =
    let
        picker =
            model.fabrics
                |> maybeRemoteData
                    (\a ->
                        div [ class "colorPicker" ]
                            (a
                                |> List.map (\a -> a.color)
                                |> List.map (\a -> colorPick a (Just a == model.selectedColor))
                            )
                    )
    in
    Accordion.view (text "Color")
        picker
        ToggleColorPicker
        model.colorPickerShown


lenghtPicker : Model -> Html Msg
lenghtPicker model =
    let
        picker =
            model.lenghts
                |> maybeRemoteData
                    (\a ->
                        div [ class "lenghtPicker" ]
                            (a
                                |> List.map
                                    (\a ->
                                        Html.label
                                            [ class
                                                (if model.lenght == Just a.value then
                                                    "radioChecked"
                                                 else
                                                    ""
                                                )
                                            ]
                                            [ input [ type_ "radio", name "lenghtPicker", onClick (LenghtChanged a.value) ] []
                                            , text a.label
                                            ]
                                    )
                            )
                    )
    in
    Accordion.view (text "Lenght")
        picker
        ToggleLenghtPicker
        model.lenghtPickerShown


toBasket : Model -> Msg
toBasket model =
    ToBasket (BasketItem.CustomItem { lenght = Maybe.withDefault 0 model.lenght, color = Maybe.withDefault "" model.selectedColor })


view : Model -> Html Msg
view model =
    div [ class "content", class "grid3" ]
        [ div [ class "controls" ]
            [ colorPicker model
            , lenghtPicker model
            ]
        , div [ class "canvas", class "wideColumn" ]
            (if render model then
                [ CreatorCanvas.creatorCanvas (Maybe.withDefault 100 model.lenght)
                    (Maybe.withDefault "" model.selectedColor)
                ]
             else
                []
            )
        , div []
            [ button
                (if render model then
                    [ onClick (toBasket model) ]
                 else
                    []
                )
                [ text "go" ]
            ]
        ]
