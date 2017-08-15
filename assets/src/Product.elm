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


type Msg
    = AfterToBasket
    | Load
    | Loaded (WebData BuyNowItem)
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
    , justAddedToBasket : Bool
    , selectedImage : String
    , zoom : Bool
    }


init : Flags -> Int -> Model
init flags i =
    { id = i
    , product = RemoteData.NotAsked
    , flags = flags
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

        ImageSelected l ->
            { model | selectedImage = l } ! []

        AfterToBasket ->
            { model | justAddedToBasket = False } ! []

        Load ->
            ( { model | product = RemoteData.Loading, zoom = False }, ProductsApi.fetchProduct model.flags model.id Loaded )

        Loaded response ->
            let
                selectedImage =
                    case response of
                        RemoteData.Success product ->
                            product.images |> List.head |> Maybe.withDefault ""

                        _ ->
                            ""
            in
            ( { model | product = response, selectedImage = selectedImage }, Cmd.none )


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


partsSection : ProductModels.BuyNowItem -> Html msg
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


ingridient : ProductModels.Ingridient -> List (Html msg)
ingridient a =
    [ dt [] [ text a.name ]
    , dd [] [ text (toString a.percentage ++ "%") ]
    ]


productView : Model -> ProductModels.BuyNowItem -> Html Msg
productView model product =
    article [ class "grid5" ]
        [ section [ class "wideColumn", class "productImages" ]
            (bigImage product model.selectedImage
                :: (product.images |> List.map smallImage)
            )
        , section [ class "productDetails", class "thinColumn" ]
            [ header []
                [ h2 [] [ text product.name ]
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
