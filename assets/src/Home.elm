module Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


navItem : String -> String -> String -> String -> String -> Html msg
navItem caption linkCaption linkHref imageUrl imageAlt =
    article [ class "navItem" ]
        [ div [ class "navItemCaption" ]
            [ Markdown.toHtml [] caption
            , a [ href linkHref ]
                [ text linkCaption
                ]
            ]
        , img [ src imageUrl, alt imageAlt ] []
        ]


view : String -> String -> String -> String -> Html msg
view home_witamy aktualna_kolekcja galeria_tkanin otworz_konfigurator =
    section [ class "content" ]
        [ header [ class "homeHeader" ]
            [ img [ class "homeHeaderImage", src "/img/home/strona tytułowa.jpg", alt "TODO" ] []
            , div [ class "homeHeaderText" ]
                [ h1 [ class "seo" ] [ text "Strona główna" ]
                , p [] [ text "Text na stronę główną" ]
                ]
            ]
        , navItem aktualna_kolekcja "Aktualna kolekcja" "#" "/img/home/poznaj kolekcję Falda.jpg" "TODO"
        , navItem otworz_konfigurator "Otwórz konfigurator" "#" "/img/home/zaprojektuj własną spódnicę.jpg" "TODO"
        , navItem galeria_tkanin "Galeria tkanin" "#" "/img/home/tkaniny.jpg" "TODO"
        , article [ class "navItem" ]
            [ div [ class "navItemCaption" ]
                [ h3 [] [ text "Falda w obiektywie" ]
                , a [ href "#" ]
                    [ text "Lookbook"
                    ]
                ]
            , img [ src "/img/home/Falda w obiektywie.jpg", alt "TODO" ] []
            ]
        ]



-- [ navItem "Poznaj kolekcję Falda" "#" "/img/kup.jpg" "nav1"
-- , navItem "Zaprojektuj własną spódnicę" "#" "/img/zaprojektuj.jpg" "nav2"
-- , navItem "Falda w obiektywie" "#" "/img/w obiektywie.jpg" "nav3"
-- , navItem "Zajrzyj do naszego świata tkanin i dodatków" "#" "/img/tkaniny.jpg" "nav4"
-- , Markdown.toHtml [ class "nav5", class "textContainer" ] home_witamy
-- ]
