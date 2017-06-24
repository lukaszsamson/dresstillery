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
    | ProductMessage Int Product.Msg
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

        ProductMessage i msg_ ->
            let
                productModel =
                    model.products
                        |> Dict.get i
                        |> Maybe.withDefault (Product.init model.flags i)
            in
            updateComponent Product.update (\a -> ProductMessage i a) msg_ productModel (\a -> { model | products = Dict.insert i a model.products })
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
            update (ProductMessage i Product.Load) model

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
            subView BuyNow.view model.buyNow BuyNowMessage

        Routing.Product i ->
            case Dict.get i model.products of
                Nothing ->
                    pageNotFound

                Just p ->
                    subView Product.view p <| ProductMessage i

        Routing.Basket ->
            subView Basket.view model.basket BasketMessage

        Routing.TermsAndConditions ->
            termsAndConditionsView

        Routing.FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Routing.Contact ->
            contactView

        Routing.Creator ->
            subView Creator.view model.creator CreatorMessage

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
