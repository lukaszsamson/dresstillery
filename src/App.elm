module App exposing (..)

import Basket
import BasketItem exposing (BasketItem)
import BuyNow
import Color exposing (Color)
import Creator
import Css
import Dict
import FontAwesome
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick, onWithOptions)
import Messages exposing (..)
import Models exposing (..)
import Navigation
import Product
import Routing


initialModel : Routing.Route -> Model
initialModel route =
    { route = route
    , menuShown = False
    , creator = Creator.init
    , basket = Basket.init
    , buyNow = BuyNow.init
    , products = Dict.empty
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
    ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateImpl (unwrapLocationChange msg) model


updateImpl : Msg -> Model -> ( Model, Cmd Msg )
updateImpl msg model =
    case msg of
        ChangeLocation route ->
            ( model, Navigation.newUrl (Routing.toPath route) )

        ToggleMenu ->
            ( { model | menuShown = not model.menuShown }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location

                newModel =
                    { model | route = newRoute }
            in
            load newModel

        CreatorMessage msg_ ->
            let
                ( creator, message ) =
                    Creator.update msg_ model.creator

                creatorMessage =
                    Cmd.map (\a -> CreatorMessage a) message

                ( model_, message_ ) =
                    case msg_ of
                        Creator.ToBasket item ->
                            addToBasket item model

                        _ ->
                            ( model, Cmd.none )
            in
            ( { model_ | creator = creator }, Cmd.batch [ creatorMessage, message_ ] )

        BuyNowMessage msg_ ->
            let
                ( buyNow, message ) =
                    BuyNow.update msg_ model.buyNow

                buyNowMessage =
                    Cmd.map (\a -> BuyNowMessage a) message

                ( model_, message_ ) =
                    case msg_ of
                        BuyNow.Loaded list ->
                            let
                                products =
                                    list
                                        |> List.map (\a -> ( a.id, a ))
                                        |> Dict.fromList
                            in
                            ( { model | products = products }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )
            in
            ( { model_ | buyNow = buyNow }, Cmd.batch [ buyNowMessage, message_ ] )

        ProductMessage msg_ i ->
            let
                ( updatedProducts, wrappedProductMessage ) =
                    case model.products |> Dict.get i of
                        Nothing ->
                            ( model.products, Cmd.none )

                        Just productModel ->
                            let
                                ( productModel_, productMessage ) =
                                    Product.update msg_ productModel
                            in
                            ( Dict.insert i productModel_ model.products
                            , Cmd.map (\a -> ProductMessage a i) productMessage
                            )

                ( model_, message_ ) =
                    case msg_ of
                        Product.ToBasket item ->
                            addToBasket item model
            in
            ( { model_ | products = updatedProducts }, Cmd.batch [ wrappedProductMessage, message_ ] )

        BasketMessage msg_ ->
            let
                ( basket, message ) =
                    Basket.update msg_ model.basket

                model_ =
                    case msg_ of
                        _ ->
                            model
            in
            ( { model_ | basket = basket }, Cmd.map (\a -> BasketMessage a) message )


unwrapLocationChange : Msg -> Msg
unwrapLocationChange msg =
    case msg of
        BuyNowMessage (BuyNow.ChangeLocation route) ->
            ChangeLocation route

        _ ->
            msg


addToBasket : BasketItem -> Model -> ( Model, Cmd Msg )
addToBasket item model =
    let
        ( basket, basketMessage ) =
            Basket.update (Basket.AddLine item) model.basket
    in
    ( { model | basket = basket }, Cmd.map (\a -> BasketMessage a) basketMessage )


load : Model -> ( Model, Cmd Msg )
load model =
    case model.route of
        Routing.BuyNow ->
            update (BuyNowMessage BuyNow.Load) model

        _ ->
            model ! []



-- VIEW
-- view : Model -> Html Msg


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


navItem : String -> String -> String -> String -> Html msg
navItem caption link imageUrl className =
    div [ class className, class "navItem" ]
        [ a [ href link ]
            [ div [ class "imgContainer", style [ ( "background-image", "url(" ++ imageUrl ++ ")" ) ] ]
                [-- [ src imageUrl ] []
                ]
            , p
                [ class className ]
                [ text caption ]
            ]
        ]


header : Html msg
header =
    div [ class "header", style [ ( "background-image", "url(img/top.jpg)" ) ] ]
        []


pageNotFound : Html msg
pageNotFound =
    div [ class "content" ] [ text "404" ]


aboutView : Html msg
aboutView =
    div [ class "content" ] [ text "about" ]


termsAndConditionsView : Html msg
termsAndConditionsView =
    div [ class "content" ] [ text "termsAndConditions" ]


fabricsAndAccesoriesView : Html msg
fabricsAndAccesoriesView =
    div [ class "content" ] [ text "fabricsAndAccesories" ]


contactView : Html msg
contactView =
    div [ class "content" ] [ text "contact" ]


homeView : Html msg
homeView =
    div [ class "content" ]
        [ navItem "trololo" "#" "img/1.jpg" "nav1"
        , navItem "bla" "#" "img/2.jpg" "nav2"
        , navItem "bla" "#" "img/3.jpg" "nav3"
        , navItem "bla" "#" "img/4.jpg" "nav4"
        , navItem "bla" "#" "img/5.jpg" "nav5"
        , navItem "bla" "#" "img/6.jpg" "negate"
        ]


mainContent : Model -> Html Msg
mainContent model =
    case model.route of
        Routing.Home ->
            homeView

        Routing.About ->
            aboutView

        Routing.BuyNow ->
            BuyNow.view model.buyNow
                |> Html.map (\a -> BuyNowMessage a)

        Routing.Product i ->
            let
                prod =
                    Dict.get i model.products
            in
            case prod of
                Nothing ->
                    pageNotFound

                Just p ->
                    Product.view p
                        |> Html.map (\a -> ProductMessage a i)

        Routing.Basket ->
            Basket.view model.basket
                |> Html.map (\a -> BasketMessage a)

        Routing.TermsAndConditions ->
            termsAndConditionsView

        Routing.FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Routing.Contact ->
            contactView

        Routing.Creator ->
            Creator.view model.creator
                |> Html.map (\a -> CreatorMessage a)

        Routing.NotFound ->
            pageNotFound


menuLink : Routing.Route -> String -> Html Msg
menuLink route label =
    li []
        [ a [ Routing.linkHref route, Routing.onLinkClick (ChangeLocation route) ] [ text label ]
        ]


menuContainer : Model -> Html Msg
menuContainer model =
    div
        [ class
            (if model.menuShown then
                "menuShown"
             else
                ""
            )
        ]
        [ menu model
        , div [ class "menuIcon", onClick ToggleMenu ] [ FontAwesome.bars (Color.rgb 0 0 0) 60 ]
        ]


menu : Model -> Html Msg
menu model =
    div [ class "menu" ]
        [ div [ class "menuClose", onClick ToggleMenu ] [ FontAwesome.close (Color.rgb 0 0 0) 10 ]
        , div [ class "logo" ] [ img [ src "img/logo.png" ] [] ]
        , ul []
            [ menuLink Routing.Home "Home"
            , menuLink Routing.About "Kim jesteśmy"
            , menuLink Routing.BuyNow "Kup teraz"
            , menuLink Routing.Creator "Zaprojektuj własną spódnicę"
            , menuLink Routing.FabricsAndAccesories "Tkaniny i akcesoria"
            , menuLink Routing.TermsAndConditions "Warunki zakupów"
            , menuLink Routing.Basket "Koszyk"
            ]
        , div [ class "social" ]
            [ FontAwesome.instagram (Color.rgb 0 0 0) 60
            , FontAwesome.facebook_official (Color.rgb 0 0 0) 60
            , FontAwesome.twitter (Color.rgb 0 0 0) 60
            ]
        ]


footer : Html Msg
footer =
    div [ class "footer" ]
        [ p [] [ text "Copyright Ⓒ ja" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ header
        , menuContainer model
        , mainContent model
        , footer
        ]
