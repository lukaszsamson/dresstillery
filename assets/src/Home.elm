module Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


navItem : String -> String -> String -> String -> String -> Html msg
navItem caption linkCaption linkHref imageUrl imageAlt =
    div [ class "navItem" ]
        [ div [ class "navItemCaption" ]
            [ p [] [ text caption ]
            , a [ href linkHref ]
                [ text linkCaption
                ]
            ]
        , img [ src imageUrl, alt imageAlt ] []
        ]


view : String -> Html msg
view home_witamy =
    div [ class "content" ]
        [ div [ class "homeHeader" ]
            [ img [ class "homeHeaderImage", src "/img/home/strona tytułowa.jpg", alt "TODO" ] []
            , div [ class "homeHeaderText" ]
                [ p [] [ text "Text na stronę główną" ] ]
            ]
        , navItem "Poznaj kolekcję Falda" "Kolekcja" "#" "/img/home/poznaj kolekcję Falda.jpg" "TODO"
        , navItem "Zaprojektuj własną spódnicę" "Otwórz kreator" "#" "/img/home/zaprojektuj własną spódnicę.jpg" "TODO"
        , navItem "Tkaniny" "Zobacz" "#" "/img/home/tkaniny.jpg" "TODO"
        , navItem "Falda w obiektywie" "Galeria" "#" "/img/home/Falda w obiektywie.jpg" "TODO"
        ]



-- [ navItem "Poznaj kolekcję Falda" "#" "/img/kup.jpg" "nav1"
-- , navItem "Zaprojektuj własną spódnicę" "#" "/img/zaprojektuj.jpg" "nav2"
-- , navItem "Falda w obiektywie" "#" "/img/w obiektywie.jpg" "nav3"
-- , navItem "Zajrzyj do naszego świata tkanin i dodatków" "#" "/img/tkaniny.jpg" "nav4"
-- , Markdown.toHtml [ class "nav5", class "textContainer" ] home_witamy
-- ]
