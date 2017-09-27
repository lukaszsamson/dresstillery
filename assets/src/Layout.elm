module Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Routing


header : (Routing.Route -> msg) -> Html msg
header changeRoute =
    div [ class "header" ]
        [ img [ src "/img/logo/Falda_logo_horizontal_black.svg", class "headerLogo", alt "Logo formy Falda" ]
            []
        , div
            [ class "headerIcons" ]
            [ -- FontAwesome.bars (Color.rgb 0 0 0) 45
              --, FontAwesome.bars (Color.rgb 0 0 0) 45
              a [ Routing.linkHref Routing.Basket, Routing.onLinkClick (changeRoute Routing.Basket) ] [ text "Koszyk" ]
            , a [ href "#" ] [ text "Zaloguj" ]
            ]
        ]


footer : Html msg
footer =
    Html.footer [ class "layoutFooter" ]
        [ section [ class "footerContent", class "grid3", class "container" ]
            [ section [ class "contactInfo" ]
                [ section [ class "companyName" ] [ text "Falda" ]
                , section [ class "companyAddress" ]
                    [ text "Ulica 123/45"
                    , br [] []
                    , text "12-123 Miasto"
                    ]
                , section [ class "companyEmail" ]
                    [ a [ href "mailto:kontakt@falda.pl" ] [ text "kontakt@falda.pl" ] ]
                ]
            , nav [ class "footerLinks" ]
                [ ul []
                    [ li [] [ a [ href "#" ] [ text "Regulamin" ] ]
                    , li [] [ a [ href "#" ] [ text "Polityka prywatności" ] ]
                    , li [] [ a [ href "#" ] [ text "Polityka zwrotów" ] ]
                    ]
                ]
            , div [] []
            ]
        , section [ class "copyrightInfo" ] [ text "Copyright Ⓒ Falda" ]
        ]


pageNotFound : Html msg
pageNotFound =
    div [ class "content" ]
        [ h1 [] [ text "404" ]
        , div [] [ text "Nie znaleziono strony" ]
        ]


aboutView : String -> Html msg
aboutView o_mnie =
    div [ class "content", class "grid3" ]
        [ Markdown.toHtml [ class "wideColumn", class "textContainer" ] o_mnie
        , div [ class "logo-woman" ] [ img [ src "/img/logo/FALDA grafika_fin.svg", alt "Logo firmy duże" ] [] ]
        ]


termsAndConditionsView : Html msg
termsAndConditionsView =
    div [ class "content" ] [ h1 [] [ text "Requlamin" ] ]


contactView : Html msg
contactView =
    div [ class "content" ] [ h1 [] [ text "Kontakt" ] ]
