module Product exposing (..)

import BasketItem exposing (BasketItem)
import CommonElements
import CommonMessages
import FabricModels
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Layout
import List.Extra
import Markdown
import Models exposing (..)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)
import Routing exposing (Route, linkHref, onLinkClick)


type Msg
    = AfterToBasket
    | Load
    | Loaded (WebData ProductsItem)
    | ImageSelected Int
    | Zoom Int
    | Parent CommonMessages.Msg


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


type alias Model =
    { product : WebData ProductsItem
    , id : Int
    , flags : Flags
    , justAddedToBasket : Bool
    , selectedImage : Maybe Int
    , zoom : Bool
    }


init : Flags -> Int -> Model
init flags i =
    { id = i
    , product = RemoteData.NotAsked
    , flags = flags
    , justAddedToBasket = False
    , selectedImage = Nothing
    , zoom = False
    }


maybeLoad : Model -> ( Model, Cmd Msg )
maybeLoad model =
    case model.product of
        RemoteData.Success p ->
            ( model, Cmd.none )

        _ ->
            ( { model | product = RemoteData.Loading }, ProductsApi.fetchProduct model.flags model.id Loaded )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Zoom s ->
            let
                model_ =
                    { model | zoom = True, selectedImage = Just s }
            in
            maybeLoad model_

        Parent (CommonMessages.ToBasket m) ->
            { model | justAddedToBasket = True } ! [ CommonElements.toBasketButtonAfter AfterToBasket ]

        Parent _ ->
            model ! []

        ImageSelected l ->
            { model | selectedImage = Just l } ! []

        AfterToBasket ->
            { model | justAddedToBasket = False } ! []

        Load ->
            let
                model_ =
                    { model | zoom = False }
            in
            maybeLoad model_

        Loaded response ->
            let
                selectedImage =
                    case model.selectedImage of
                        Just x ->
                            Just x

                        Nothing ->
                            case response of
                                RemoteData.Success product ->
                                    Just 0

                                _ ->
                                    Nothing
            in
            ( { model | product = response, selectedImage = selectedImage }, Cmd.none )


smallImage : Int -> String -> Html Msg
smallImage i url =
    div [ class "productThumbnali" ] [ img [ src url, onClick (ImageSelected i) ] [] ]


bigImage : ProductsItem -> Maybe Int -> Html Msg
bigImage product selectedImage =
    let
        image =
            product.images
                |> getSelected selectedImage

        index =
            selectedImage |> Maybe.withDefault -1

        route =
            Routing.ProductZoom product.id index
    in
    div [ class "productMainImage" ]
        [ a [ class "zoomLink", linkHref route, onLinkClick (Parent <| CommonMessages.ChangeLocation route) ] [ img [ src image ] [] ]
        ]


partsSection : ProductModels.ProductsItem -> Html msg
partsSection product =
    section []
        (h3 [] [ text "Skład" ]
            :: (product.parts |> List.map part)
        )


part : ProductModels.Part -> Html msg
part p =
    article []
        [ h4 [] [ text p.name ]
        , dl [] (p.ingridients |> List.map ingridient |> List.concat)
        ]


ingridient : FabricModels.Ingridient -> List (Html msg)
ingridient a =
    [ dt [] [ text a.name ]
    , dd [] [ text (toString a.percentage ++ "%") ]
    ]


productView : Model -> ProductModels.ProductsItem -> Html Msg
productView model product =
    article [ class "grid5" ]
        [ section [ class "wideColumn", class "productImages" ]
            (bigImage product model.selectedImage
                :: (product.images |> List.indexedMap smallImage)
            )
        , section [ class "productDetails", class "thinColumn" ]
            [ header []
                [ h2 []
                    [ text
                        (product.name
                            ++ (if product.hidden then
                                    " - Ukryty"
                                else
                                    ""
                               )
                        )
                    ]
                , small [] [ text product.code ]
                ]
            , div [ class "productPrice" ] [ text (toString product.price ++ " zł") ]
            , section []
                [ h3 [] [ text "Opis" ]
                , Markdown.toHtml [] product.shortDescription
                , Markdown.toHtml [] product.mainDescription
                , Markdown.toHtml [] product.specificDescription
                ]
            , partsSection product

            -- , h3 [] [ text "Dostępne warianty" ]
            -- , CommonElements.lenghtPicker product.lenghts model.selectedLenght LenghtChanged
            , div [ class "productBasket" ]
                -- TODO
                [ CommonElements.toBasketButton model.justAddedToBasket (Parent <| CommonMessages.ToBasket (BasketItem.CatalogItem { item = product, lenght = Mini }))
                ]
            ]
        ]


maybeProduct : Model -> Html Msg
maybeProduct model =
    case model.product of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success product ->
            productView model product

        RemoteData.Failure error ->
            case error of
                Http.BadStatus s ->
                    if s.status.code == 404 then
                        Layout.pageNotFound
                    else
                        text (toString error)

                _ ->
                    text (toString error)


getSelected : Maybe Int -> List String -> String
getSelected selectedImage images =
    images
        |> List.Extra.getAt (selectedImage |> Maybe.withDefault -1)
        |> Maybe.withDefault ""


zoom : Model -> Html Msg
zoom model =
    let
        route =
            Routing.Product (model.product |> RemoteData.toMaybe |> Maybe.map .id |> Maybe.withDefault 0)

        image =
            model.product
                |> RemoteData.toMaybe
                |> Maybe.map .images
                |> Maybe.withDefault []
                |> getSelected model.selectedImage
    in
    div [ class "imageZoomContainer", onLinkClick (Parent <| CommonMessages.ChangeLocation route) ]
        [ img [ src image ] []
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        (maybeProduct model
            :: (if model.zoom then
                    [ zoom model ]
                else
                    []
               )
        )
