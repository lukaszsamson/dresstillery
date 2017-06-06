module App exposing (..)

import BuyNow
import Color exposing (Color)
import Creator
import Css
import FontAwesome
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Models exposing (..)
import Navigation
import Routing exposing (parseLocation, path)
import Time
import Utils exposing (delay)


initialModel : Route -> Model
initialModel route =
    { route = route
    , menuShown = False
    , creator = Creator.init
    , basket = False
    , buyNow = BuyNow.init
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
    ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        ToggleMenu ->
            ( { model | menuShown = not model.menuShown }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                newModel =
                    { model | route = newRoute }
            in
            load newModel

        CreatorMessage msg_ ->
            let
                ( creator, message ) =
                    Creator.update msg_ model.creator

                model_ =
                    case msg_ of
                        Creator.ToBasket ->
                            { model | basket = not model.basket }

                        _ ->
                            model
            in
            ( { model_ | creator = creator }, Cmd.map (\a -> CreatorMessage a) message )

        BuyNowMessage msg_ ->
            let
                ( buyNow, message ) =
                    BuyNow.update msg_ model.buyNow

                model_ =
                    case msg_ of
                        _ ->
                            model
            in
            ( { model_ | buyNow = buyNow }, Cmd.map (\a -> BuyNowMessage a) message )


load : Model -> ( Model, Cmd Msg )
load model =
    case model.route of
        BuyNow ->
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
        Home ->
            homeView

        About ->
            aboutView

        BuyNow ->
            BuyNow.view model.buyNow
                |> Html.map (\a -> BuyNowMessage a)

        TermsAndConditions ->
            termsAndConditionsView

        FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Contact ->
            contactView

        Creator ->
            Creator.view model.creator
                |> Html.map (\a -> CreatorMessage a)

        NotFound ->
            pageNotFound


{-| When clicking a link we want to prevent the default browser behaviour which is to load a new page.
So we use `onWithOptions` instead of `onClick`.
-}
onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    onWithOptions "click" options (Decode.succeed message)


menuLink : String -> String -> Html Msg
menuLink path label =
    li []
        [ a [ href path, onLinkClick (ChangeLocation path) ] [ text label ]
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
            [ menuLink (path Home) "Home"
            , menuLink (path About) "Kim jesteśmy"
            , menuLink (path BuyNow) "Kup teraz"
            , menuLink (path Creator) "Zaprojektuj własną spódnicę"
            , menuLink (path FabricsAndAccesories) "Tkaniny i akcesoria"
            , menuLink (path TermsAndConditions) "Warunki zakupów"
            ]
        , p [] [ text (toString model.basket) ]
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
