module Layout exposing (..)

import CommonElements exposing (icon)
import FontAwesome
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Routing


header : (Routing.Route -> msg) -> msg -> Html msg
header changeRoute login =
    Html.header [ class "header" ]
        [ img [ src "/img/logo/Falda_logo_horizontal_black.svg", class "headerLogo", alt "Logo formy Falda" ]
            []
        , div
            [ class "headerIcons" ]
            [ -- FontAwesome.bars (Color.rgb 0 0 0) 45
              --, FontAwesome.bars (Color.rgb 0 0 0) 45
              a [ Routing.linkHref Routing.Basket, Routing.onLinkClick (changeRoute Routing.Basket) ]
                [ icon FontAwesome.shopping_bag
                , span [] [ text "Koszyk" ]
                ]
            , a [ href "#", onClick login ] [ icon FontAwesome.sign_in, span [] [ text "Zaloguj" ] ]
            ]
        ]


footer : Html msg
footer =
    Html.footer [ class "layoutFooter" ]
        [ div [ class "footerContent", class "grid3", class "container" ]
            [ section []
                [ address [ class "contactInfo" ]
                    [ h3 [ class "seo" ] [ text "Informacje kontaktowe" ]
                    , div [ class "companyName" ] [ h4 [ class "seo" ] [ text "Nazwa firmy" ], text "Falda" ]
                    , div [ class "companyAddress" ]
                        [ h4 [ class "seo" ] [ text "Adres" ]
                        , text "Ulica 123/45"
                        , br [] []
                        , text "12-123 Miasto"
                        ]
                    , div [ class "companyEmail" ]
                        [ h4 [ class "seo" ] [ text "Adres email" ]
                        , a [ href "mailto:kontakt@falda.pl" ] [ text "kontakt@falda.pl" ]
                        ]
                    ]
                ]
            , nav [ class "footerLinks" ]
                [ h3 [ class "seo" ] [ text "Odnośniki do informacji prawnych" ]
                , ul []
                    [ li [] [ a [ href "#" ] [ text "Regulamin" ] ]
                    , li [] [ a [ href "#" ] [ text "Polityka prywatności" ] ]
                    , li [] [ a [ href "#" ] [ text "Polityka zwrotów" ] ]
                    ]
                ]
            , div [] []
            ]
        , section [ class "copyrightInfo" ]
            [ h3 [ class "seo" ] [ text "Informacje o prawach autorskich" ]
            , text "Copyright Ⓒ Falda"
            ]
        ]


pageNotFound : Html msg
pageNotFound =
    section [ class "content" ]
        [ h1 [] [ text "404" ]
        , div [] [ text "Nie znaleziono strony" ]
        ]


aboutView : String -> Html msg
aboutView o_mnie =
    section [ class "content", class "grid3" ]
        [ Markdown.toHtml [ class "wideColumn", class "textContainer" ] o_mnie
        , div [ class "logo-woman" ] [ img [ src "/img/logo/FALDA grafika_fin.svg", alt "Logo firmy duże" ] [] ]
        ]


termsAndConditionsView : Html msg
termsAndConditionsView =
    section [ class "content" ] [ h1 [] [ text "Requlamin" ] ]


contactView : Html msg
contactView =
    section [ class "content" ] [ h1 [] [ text "Kontakt" ] ]
