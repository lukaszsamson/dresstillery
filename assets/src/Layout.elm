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
    div [ class "footer" ]
        [ p [] [ text "Copyright Ⓒ ja" ]
        ]


pageNotFound : Html msg
pageNotFound =
    div [ class "content" ] [ text "404" ]


aboutView : String -> Html msg
aboutView o_mnie =
    div [ class "content", class "grid3" ]
        [ Markdown.toHtml [ class "wideColumn", class "textContainer" ] o_mnie
        , div [ class "logo-woman" ] [ img [ src "/img/logo/FALDA grafika_fin.svg", alt "Logo firmy duże" ] [] ]
        ]


termsAndConditionsView : Html msg
termsAndConditionsView =
    div [ class "content" ] [ text "termsAndConditions" ]


contactView : Html msg
contactView =
    div [ class "content" ] [ text "contact" ]
