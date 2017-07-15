module Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


header : Html msg
header =
    div [ class "header", style [ ( "background-image", "url(/img/top.jpg)" ) ] ]
        []


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
        [ div [ class "wideColumn" ] [ Markdown.toHtml [] o_mnie ]
        , div [ class "logo-woman" ] [ img [src "/img/logo/FALDA grafika_fin.svg"] [] ]
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
