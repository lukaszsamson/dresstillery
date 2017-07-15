module App exposing (..)

import Basket
import BuyNow
import CommonMessages
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
    = OnLocationChange Navigation.Location
    | ToggleMenu
    | BuyNowMessage BuyNow.Msg (Maybe CommonMessages.Msg)
    | ProductMessage Int Product.Msg (Maybe CommonMessages.Msg)
    | CreatorMessage Creator.Msg (Maybe CommonMessages.Msg)
    | BasketMessage Basket.Msg (Maybe CommonMessages.Msg)
    | CommonMessage CommonMessages.Msg


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
    update (OnLocationChange location) (initialModel flags)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CommonMessage (CommonMessages.ToBasket item) ->
            updateComponent_ basket (Basket.AddLine item) Nothing model

        CommonMessage (CommonMessages.ChangeLocation route) ->
            ( { model | menuShown = False }, Navigation.newUrl (Routing.toPath route) )

        ToggleMenu ->
            ( { model | menuShown = not model.menuShown }, Cmd.none )

        OnLocationChange location ->
            let
                route =
                    Routing.parseLocation location
            in
            load route { model | route = route }

        CreatorMessage cMsg pMsg ->
            updateComponent_ creator cMsg pMsg model

        BuyNowMessage cMsg pMsg ->
            updateComponent_ buyNow cMsg pMsg model

        ProductMessage i cMsg pMsg ->
            updateComponent_ (product i) cMsg pMsg model

        BasketMessage cMsg pMsg ->
            updateComponent_ basket cMsg pMsg model


load : Routing.Route -> Model -> ( Model, Cmd Msg )
load route =
    case route of
        Routing.Creator ->
            updateComponent_ creator Creator.Load Nothing

        Routing.BuyNow ->
            updateComponent_ buyNow BuyNow.Load Nothing

        Routing.Product i ->
            updateComponent_ (product i) Product.Load Nothing

        _ ->
            \m -> m ! []


updateComponent_ :
    Component Model Msg modelC msgC
    -> msgC
    -> Maybe CommonMessages.Msg
    -> Model
    -> ( Model, Cmd Msg )
updateComponent_ c msg pmsg m =
    updateComponent c m msg pmsg (\v -> update (CommonMessage v))


changeLocation : Routing.Route -> Msg
changeLocation =
    \r -> CommonMessage <| CommonMessages.ChangeLocation r


mainContent : Model -> Html Msg
mainContent model =
    case model.route of
        Routing.Home ->
            Home.view

        Routing.About ->
            aboutView model.flags.o_mnie

        Routing.BuyNow ->
            subView buyNow model

        Routing.Product i ->
            subView (product i) model

        Routing.Basket ->
            subView basket model

        Routing.TermsAndConditions ->
            termsAndConditionsView

        Routing.FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Routing.Contact ->
            contactView

        Routing.Creator ->
            subView creator model

        Routing.NotFound ->
            pageNotFound


view : Model -> Html Msg
view model =
    div []
        [ header
        , Menu.menuContainer model.menuShown ToggleMenu changeLocation
        , mainContent model
        , footer
        ]


basket : Component Model Msg Basket.Model Basket.Msg
basket =
    { getter = \m -> m.basket
    , setter = \m b -> { m | basket = b }
    , update = Basket.update
    , view = Basket.view
    , wrap = wrap BasketMessage Basket.toParent
    }


creator : Component Model Msg Creator.Model Creator.Msg
creator =
    { getter = \m -> m.creator
    , setter = \m b -> { m | creator = b }
    , update = Creator.update
    , view = Creator.view
    , wrap = wrap CreatorMessage Creator.toParent
    }


buyNow : Component Model Msg BuyNow.Model BuyNow.Msg
buyNow =
    { getter = \m -> m.buyNow
    , setter = \m b -> { m | buyNow = b }
    , update = BuyNow.update
    , view = BuyNow.view
    , wrap = wrap BuyNowMessage BuyNow.toParent
    }


product : Int -> Component Model Msg Product.Model Product.Msg
product i =
    { getter =
        \m ->
            m.products
                |> Dict.get i
                |> Maybe.withDefault (Product.init m.flags i)
    , setter = \m a -> { m | products = Dict.insert i a m.products }
    , update = Product.update
    , view = Product.view
    , wrap = wrap (ProductMessage i) Product.toParent
    }
