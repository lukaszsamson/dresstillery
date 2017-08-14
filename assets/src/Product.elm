module Product exposing (..)

import BasketItem exposing (BasketItem)
import CommonElements
import CommonMessages
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Layout
import Markdown
import Models exposing (..)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)
import Routing exposing (Route, linkHref, onLinkClick)
import Utils exposing (productText)


type Msg
    = AfterToBasket
    | Load
    | Loaded (WebData BuyNowItem)
    | LenghtChanged Lenght
    | ImageSelected String
    | Zoom String
    | Parent CommonMessages.Msg


toParent : Msg -> Maybe CommonMessages.Msg
toParent msg =
    case msg of
        Parent m ->
            Just m

        _ ->
            Nothing


type alias Model =
    { product : WebData BuyNowItem
    , id : Int
    , flags : Flags
    , selectedLenght : Maybe Lenght
    , justAddedToBasket : Bool
    , selectedImage : String
    , zoom : Bool
    }


init : Flags -> Int -> Model
init flags i =
    { id = i
    , product = RemoteData.NotAsked
    , flags = flags
    , selectedLenght = Nothing
    , justAddedToBasket = False
    , selectedImage = ""
    , zoom = False
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Zoom s ->
            { model | zoom = True } ! []

        Parent (CommonMessages.ToBasket m) ->
            { model | justAddedToBasket = True } ! [ CommonElements.toBasketButtonAfter AfterToBasket ]

        Parent _ ->
            model ! []

        LenghtChanged l ->
            { model | selectedLenght = Just l } ! []

        ImageSelected l ->
            { model | selectedImage = l } ! []

        AfterToBasket ->
            { model | justAddedToBasket = False } ! []

        Load ->
            ( { model | product = RemoteData.Loading, zoom = False }, ProductsApi.fetchProduct model.flags model.id Loaded )

        Loaded response ->
            let
                ( selectedLenght, selectedImage ) =
                    case response of
                        RemoteData.Success product ->
                            ( List.head product.lenghts, product.images |> List.head |> Maybe.withDefault "" )

                        _ ->
                            ( Nothing, "" )
            in
            ( { model | product = response, selectedLenght = selectedLenght, selectedImage = selectedImage }, Cmd.none )


smallImage : String -> Html Msg
smallImage url =
    div [ class "productThumbnali" ] [ img [ src url, onClick (ImageSelected url) ] [] ]


bigImage : BuyNowItem -> String -> Html Msg
bigImage product selectedImage =
    let
        image =
            selectedImage |> String.split "/" |> List.filter (\x -> x |> String.contains ".") |> List.head |> Maybe.withDefault ""

        route =
            Routing.ProductZoom product.id image
    in
    div [ class "productMainImage" ]
        [ a [ class "zoomLink", linkHref route, onLinkClick (Parent <| CommonMessages.ChangeLocation route) ] [ img [ src selectedImage ] [] ]
        ]


maybeProduct : Model -> Html Msg
maybeProduct model =
    case model.product of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success product ->
            div [ class "grid5" ]
                [ div [ class "wideColumn", class "productImages" ]
                    (bigImage product model.selectedImage
                        :: (product.images |> List.map smallImage)
                    )
                , div [ class "productDetails", class "thinColumn" ]
                    [ h2 [] [ text product.label ]
                    , div [ class "productPrice" ] [ text (toString product.price ++ " zł") ]
                    , h3 [] [ text "Opis" ]
                    , div [] [ Markdown.toHtml [] productText ]
                    , h3 [] [ text "Skład" ]
                    , dl []
                        (product.ingridients
                            |> List.concatMap
                                (\a ->
                                    [ dt [] [ text a.name ]
                                    , dd [] [ text (toString a.percentage ++ "%") ]
                                    ]
                                )
                        )
                    , h3 [] [ text "Dostępne warianty" ]
                    , CommonElements.lenghtPicker product.lenghts model.selectedLenght LenghtChanged
                    , div [ class "productBasket" ]
                        [ CommonElements.toBasketButton model.justAddedToBasket (Parent <| CommonMessages.ToBasket (BasketItem.CatalogItem { item = product, lenght = Maybe.withDefault Mini model.selectedLenght }))
                        ]
                    ]
                ]

        RemoteData.Failure error ->
            case error of
                Http.BadStatus s ->
                    if s.status.code == 404 then
                        Layout.pageNotFound
                    else
                        text (toString error)

                _ ->
                    text (toString error)


zoom : Model -> Html Msg
zoom model =
    let
        route =
            Routing.Product (model.product |> RemoteData.toMaybe |> Maybe.map .id |> Maybe.withDefault 0)
    in
    div [ class "imageZoomContainer", onLinkClick (Parent <| CommonMessages.ChangeLocation route) ]
        [ img [ src model.selectedImage ] []
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
