module Menu exposing (..)

import Color
import CommonElements exposing (icon)
import FontAwesome
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (class, classList, href, src, style)
import Html.Events exposing (onClick, onWithOptions)
import Routing


menuLink : Routing.Route -> String -> (Routing.Route -> msg) -> Html msg
menuLink route label msg =
    li []
        [ a [ Routing.linkHref route, Routing.onLinkClick (msg route) ] [ text label ]
        ]


menuContainer : Bool -> msg -> (Routing.Route -> msg) -> Html msg
menuContainer menuShown toggle changeRoute =
    div
        [ classList [ ( "menuShown", menuShown ) ]
        ]
        [ menu changeRoute
        , div [ class "menuIcon", class "icon", onClick toggle ] [ FontAwesome.bars (Color.rgb 0 0 0) 45 ]
        ]


menu : (Routing.Route -> msg) -> Html msg
menu changeRoute =
    let
        l =
            \r l -> menuLink r l changeRoute
    in
    div [ class "menu" ]
        [ div [ class "logo" ] [ img [ src "/img/logo.png" ] [] ]
        , ul []
            [ l Routing.Home "Home"
            , l Routing.About "Kim jesteśmy"
            , l Routing.BuyNow "Kup teraz"
            , l Routing.Creator "Zaprojektuj własną spódnicę"
            , l Routing.FabricsAndAccesories "Tkaniny i akcesoria"
            , l Routing.TermsAndConditions "Warunki zakupów"
            , l Routing.Basket "Koszyk"
            ]
        , div [ class "social" ]
            [ icon FontAwesome.instagram
            , icon FontAwesome.facebook_official
            , icon FontAwesome.twitter
            ]
        ]
