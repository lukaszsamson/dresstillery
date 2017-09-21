module Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


header : Html msg
header =
    div [ class "header" ]
        [ img [ src "/img/logo/Falda_logo_horizontal_black.svg", class "headerLogo", alt "Logo firmy" ]
            []
        , div
            [ class "headerIcons" ]
            [ -- FontAwesome.bars (Color.rgb 0 0 0) 45
              --, FontAwesome.bars (Color.rgb 0 0 0) 45
              a [ href "#" ] [ text "Koszyk" ]
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


fabricsAndAccesoriesView : Html msg
fabricsAndAccesoriesView =
    div [ class "content" ] [ text "fabricsAndAccesories" ]


contactView : Html msg
contactView =
    div [ class "content" ] [ text "contact" ]
