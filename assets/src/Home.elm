module Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Routing


navItem : (Routing.Route -> msg) -> String -> String -> Routing.Route -> String -> String -> Html msg
navItem changeRoute caption linkCaption route imageUrl imageAlt =
    article [ class "navItem" ]
        [ div [ class "navItemCaption" ]
            [ Markdown.toHtml [] caption
            , a [ Routing.linkHref route, Routing.onLinkClick <| changeRoute route ]
                [ text linkCaption
                ]
            ]
        , img [ src imageUrl, alt imageAlt ] []
        ]


view : (Routing.Route -> msg) -> String -> String -> String -> String -> Html msg
view changeRoute home_witamy aktualna_kolekcja galeria_tkanin otworz_konfigurator =
    section [ class "content" ]
        [ header [ class "homeHeader" ]
            [ img [ class "homeHeaderImage", src "/img/home/strona tytułowa.jpg", alt "TODO" ] []
            , div [ class "homeHeaderText" ]
                [ h1 [ class "seo" ] [ text "Strona główna" ]
                , p [] [ text "Text na stronę główną" ]
                ]
            ]
        , navItem changeRoute aktualna_kolekcja "Aktualna kolekcja" Routing.Products "/img/home/poznaj kolekcję Falda.jpg" "TODO"
        , navItem changeRoute otworz_konfigurator "Otwórz konfigurator" Routing.Creator "/img/home/zaprojektuj własną spódnicę.jpg" "TODO"
        , navItem changeRoute galeria_tkanin "Galeria tkanin" Routing.Fabrics "/img/home/tkaniny.jpg" "TODO"
        , article [ class "navItem" ]
            [ div [ class "navItemCaption" ]
                [ h3 [] [ text "Falda w obiektywie" ]
                , a [ href "#TODO" ]
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
