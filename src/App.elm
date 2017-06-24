module App exposing (..)

import Basket
import BasketItem exposing (BasketItem)
import BuyNow
import Creator
import Dict
import Home
import Html exposing (Html, div)
import Layout exposing (..)
import Menu
import Models exposing (..)
import Navigation
import Product
import Routing
import Utils exposing (..)


type Msg
    = ChangeLocation Routing.Route
    | OnLocationChange Navigation.Location
    | ToggleMenu
    | BuyNowMessage BuyNow.Msg
    | ProductMessage Product.Msg Int
    | CreatorMessage Creator.Msg
    | BasketMessage Basket.Msg


type alias Model =
    { route : Routing.Route
    , flags : Flags
    , menuShown : Bool
    , buyNow : BuyNow.Model
    , creator : Creator.Model
    , basket : Basket.Model
    , products : Dict.Dict Int Product.Model
    }


initialModel : Flags -> Model
initialModel flags =
    { route = Routing.Home
    , flags = flags
    , menuShown = False
    , creator = Creator.init flags
    , basket = Basket.init
    , buyNow = BuyNow.init flags
    , products = Dict.empty
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    updateImpl (OnLocationChange location) (initialModel flags)


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
            ( { model | menuShown = False }, Navigation.newUrl (Routing.toPath route) )

        ToggleMenu ->
            ( { model | menuShown = not model.menuShown }, Cmd.none )

        OnLocationChange location ->
            let
                route =
                    Routing.parseLocation location
            in
            load { model | route = route }

        CreatorMessage msg_ ->
            updateComponent Creator.update CreatorMessage msg_ model.creator (\a -> { model | creator = a })
                |> updateParent
                    (\a ->
                        case msg_ of
                            Creator.ToBasket item ->
                                addToBasket item a

                            _ ->
                                ( a, Cmd.none )
                    )

        BuyNowMessage msg_ ->
            updateComponent BuyNow.update BuyNowMessage msg_ model.buyNow (\a -> { model | buyNow = a })

        ProductMessage msg_ i ->
            let
                productModel =
                    model.products
                        |> Dict.get i
                        |> Maybe.withDefault (Product.init model.flags i)
            in
            updateComponent Product.update (\a -> ProductMessage a i) msg_ productModel (\a -> { model | products = Dict.insert i a model.products })
                |> updateParent
                    (\a ->
                        case msg_ of
                            Product.ToBasket item ->
                                addToBasket item a

                            _ ->
                                ( a, Cmd.none )
                    )

        BasketMessage msg_ ->
            updateComponent Basket.update BasketMessage msg_ model.basket (\a -> { model | basket = a })


unwrapLocationChange : Msg -> Msg
unwrapLocationChange msg =
    case msg of
        BuyNowMessage (BuyNow.ChangeLocation route) ->
            ChangeLocation route

        BasketMessage (Basket.ChangeLocation route) ->
            ChangeLocation route

        _ ->
            msg


addToBasket : BasketItem -> Model -> ( Model, Cmd Msg )
addToBasket item model =
    updateImpl (BasketMessage (Basket.AddLine item)) model


load : Model -> ( Model, Cmd Msg )
load model =
    case model.route of
        Routing.Creator ->
            update (CreatorMessage Creator.Load) model

        Routing.BuyNow ->
            update (BuyNowMessage BuyNow.Load) model

        Routing.Product i ->
            update (ProductMessage Product.Load i) model

        _ ->
            model ! []



-- VIEW
-- view : Model -> Html Msg


mainContent : Model -> Html Msg
mainContent model =
    case model.route of
        Routing.Home ->
            Home.view

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


view : Model -> Html Msg
view model =
    div []
        [ header
        , Menu.menuContainer model.menuShown ToggleMenu ChangeLocation
        , mainContent model
        , footer
        ]
