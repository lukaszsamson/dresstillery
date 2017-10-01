module App exposing (..)

import Basket
import CommonMessages
import Creator
import Dict
import Fabrics
import Home
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Layout exposing (..)
import Menu
import Models exposing (..)
import Navigation
import Product
import Products
import Routing
import Utils exposing (..)


type Msg
    = OnLocationChange Navigation.Location
    | ToggleMenu
    | FabricsMessage Fabrics.Msg (Maybe CommonMessages.Msg)
    | ProductsMessage Products.Msg (Maybe CommonMessages.Msg)
    | ProductMessage Int Product.Msg (Maybe CommonMessages.Msg)
    | CreatorMessage Creator.Msg (Maybe CommonMessages.Msg)
    | BasketMessage Basket.Msg (Maybe CommonMessages.Msg)
    | CommonMessage CommonMessages.Msg


type alias Model =
    { route : Routing.Route
    , flags : Flags
    , menuShown : Bool
    , products : Products.Model
    , fabrics : Fabrics.Model
    , creator : Creator.Model
    , basket : Basket.Model
    , productDict : Dict.Dict Int Product.Model
    }


initialModel : Flags -> Model
initialModel flags =
    { route = Routing.Home
    , flags = flags
    , menuShown = False
    , creator = Creator.init flags
    , basket = Basket.init
    , products = Products.init flags
    , fabrics = Fabrics.init flags
    , productDict = Dict.empty
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
        CommonMessage cmsg ->
            updateCommon cmsg model

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

        FabricsMessage cMsg pMsg ->
            updateComponent_ fabrics cMsg pMsg model

        ProductsMessage cMsg pMsg ->
            updateComponent_ products cMsg pMsg model

        ProductMessage i cMsg pMsg ->
            updateComponent_ (product i) cMsg pMsg model

        BasketMessage cMsg pMsg ->
            updateComponent_ basket cMsg pMsg model


updateCommon : CommonMessages.Msg -> Model -> ( Model, Cmd Msg )
updateCommon msg model =
    case msg of
        CommonMessages.ToBasket item ->
            updateComponent_ basket (Basket.AddLine item) Nothing model

        CommonMessages.ChangeLocation route ->
            ( { model | menuShown = False }, Navigation.newUrl (Routing.toPath route) )


load : Routing.Route -> Model -> ( Model, Cmd Msg )
load route =
    case route of
        Routing.Creator ->
            updateComponent_ creator Creator.Load Nothing

        Routing.Fabrics ->
            updateComponent_ fabrics Fabrics.Load Nothing

        Routing.Products ->
            updateComponent_ products Products.Load Nothing

        Routing.Product i ->
            updateComponent_ (product i) Product.Load Nothing

        Routing.ProductZoom i j ->
            updateComponent_ (product i) (Product.Zoom j) Nothing

        _ ->
            \m -> m ! []


updateComponent_ :
    Component Model Msg modelC msgC
    -> msgC
    -> Maybe CommonMessages.Msg
    -> Model
    -> ( Model, Cmd Msg )
updateComponent_ c msg pmsg m =
    updateComponent c m msg pmsg (update << CommonMessage)


changeLocation : Routing.Route -> Msg
changeLocation =
    CommonMessage << CommonMessages.ChangeLocation


mainContent : Model -> Html Msg
mainContent model =
    case model.route of
        Routing.Home ->
            Home.view model.flags.home_witamy model.flags.aktualna_kolekcja model.flags.galeria_tkanin model.flags.otworz_konfigurator

        Routing.About ->
            aboutView model.flags.o_mnie

        Routing.Products ->
            subView products model

        Routing.Fabrics ->
            subView fabrics model

        Routing.Product i ->
            subView (product i) model

        Routing.ProductZoom i j ->
            subView (product i) model

        Routing.Basket ->
            subView basket model

        Routing.TermsAndConditions ->
            termsAndConditionsView

        Routing.Contact ->
            contactView

        Routing.Creator ->
            subView creator model

        Routing.NotFound ->
            pageNotFound


view : Model -> Html Msg
view model =
    div [ class "wrap" ]
        [ header changeLocation
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


fabrics : Component Model Msg Fabrics.Model Fabrics.Msg
fabrics =
    { getter = \m -> m.fabrics
    , setter = \m b -> { m | fabrics = b }
    , update = Fabrics.update
    , view = Fabrics.view
    , wrap = wrap FabricsMessage Fabrics.toParent
    }


products : Component Model Msg Products.Model Products.Msg
products =
    { getter = \m -> m.products
    , setter = \m b -> { m | products = b }
    , update = Products.update
    , view = Products.view
    , wrap = wrap ProductsMessage Products.toParent
    }


product : Int -> Component Model Msg Product.Model Product.Msg
product i =
    { getter =
        \m ->
            m.productDict
                |> Dict.get i
                |> Maybe.withDefault (Product.init m.flags i)
    , setter = \m a -> { m | productDict = Dict.insert i a m.productDict }
    , update = Product.update
    , view = Product.view
    , wrap = wrap (ProductMessage i) Product.toParent
    }
