module Menu exposing (..)

import Color
import CommonElements exposing (icon)
import FontAwesome
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (alt, class, classList, href, src, style, title)
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
        , div [ class "menuOverlay", onClick toggle ] []
        ]


menu : (Routing.Route -> msg) -> Html msg
menu changeRoute =
    let
        l =
            \r l -> menuLink r l changeRoute
    in
    Html.nav [ class "menu" ]
        [ Html.h5 [ class "seo" ] [ text "Menu główne" ]
        , div [ class "logo" ]
            [ a [ Routing.linkHref Routing.Home, Routing.onLinkClick <| changeRoute Routing.Home, title "Strona główna" ]
                [ img [ src "/img/logo/Falda_logo_vertical_black.svg", alt "Logo falda" ] [] ]
            ]
        , ul []
            [ l Routing.About "Kim jesteśmy"
            , l Routing.Products "Nasza kolekcja"
            , l Routing.Creator "Zaprojektuj własną spódnicę"
            , l Routing.Fabrics "Tkaniny i dodatki"

            -- TODO "Falda w obiektywie"
            -- TODO "Kontakt"
            -- , l Routing.TermsAndConditions "Warunki zakupów"
            -- , l Routing.Basket "Koszyk"
            ]
        , Html.section [ class "social" ]
            [ Html.h3 [ class "seo" ] [ text "Odnośniki do profili Falda na portalach społecznościowych" ]
            , icon FontAwesome.instagram
            , icon FontAwesome.facebook_official
            , icon FontAwesome.twitter
            ]
        ]
