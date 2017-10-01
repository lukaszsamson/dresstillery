module Creator exposing (..)

import Accordion
import BasketItem exposing (BasketItem)
import CommonElements
import CommonMessages
import CreatorApi
import CreatorCanvas
import CreatorModels exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import ProductModels
import RemoteData exposing (WebData)


type Msg
    = ColorPicked String
    | Parent CommonMessages.Msg
    | AfterToBasket
    | LenghtChanged ProductModels.Lenght
    | ToggleColorPicker Accordion.Msg
    | ToggleLenghtPicker Accordion.Msg
    | Load
    | FabricsLoaded (WebData (List Fabric))
    | LenghtsLoaded (WebData (List Length))


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


type alias Model =
    { selectedColor : Maybe String
    , lenght : Maybe ProductModels.Lenght
    , colorPickerShown : Accordion.Model
    , lenghtPickerShown : Accordion.Model
    , fabrics : WebData (List Fabric)
    , lenghts : WebData (List Length)
    , flags : Flags
    , justAddedToBasket : Bool
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
    , justAddedToBasket = False
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

        Parent (CommonMessages.ToBasket m) ->
            { model | justAddedToBasket = True } ! [ CommonElements.toBasketButtonAfter AfterToBasket ]

        Parent _ ->
            model ! []

        AfterToBasket ->
            { model | justAddedToBasket = False } ! []


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


lenghtInCentimeters : ProductModels.Lenght -> number
lenghtInCentimeters l =
    case l of
        ProductModels.Mini ->
            40

        ProductModels.Midi ->
            60


allLenghts : List ProductModels.Lenght
allLenghts =
    [ ProductModels.Mini, ProductModels.Midi ]


lenghtPicker : Model -> Html Msg
lenghtPicker model =
    let
        picker =
            CommonElements.lenghtPicker allLenghts model.lenght LenghtChanged
    in
    Accordion.view (text "Lenght")
        picker
        ToggleLenghtPicker
        model.lenghtPickerShown


toBasket : Model -> Msg
toBasket model =
    Parent <| CommonMessages.ToBasket (BasketItem.CustomItem { lenght = Maybe.withDefault ProductModels.Mini model.lenght, color = Maybe.withDefault "" model.selectedColor })


view : Model -> Html Msg
view model =
    section [ class "content", class "grid3" ]
        [ div [ class "controls" ]
            [ colorPicker model
            , lenghtPicker model
            ]
        , div [ class "canvas", class "wideColumn" ]
            (if render model then
                [ CreatorCanvas.creatorCanvas
                    (lenghtInCentimeters <|
                        Maybe.withDefault ProductModels.Mini model.lenght
                    )
                    (Maybe.withDefault "" model.selectedColor)
                ]
             else
                []
            )
        , div []
            (if render model then
                [ CommonElements.toBasketButton model.justAddedToBasket (toBasket model)
                ]
             else
                []
            )
        ]
