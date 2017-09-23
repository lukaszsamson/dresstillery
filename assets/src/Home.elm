module Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


navItem : String -> String -> String -> String -> Html msg
navItem caption link imageUrl className =
    div [ class className, class "navItem" ]
        [ a [ href link ]
            [ div [ class "imgContainer", style [ ( "background-image", "url(" ++ imageUrl ++ ")" ) ] ]
                [-- [ src imageUrl ] []
                ]
            , p
                [ class className ]
                [ text caption ]
            ]
        ]


view : Html msg
view =
    div [ class "content", class "grid3" ]
        [ navItem "trololo" "#" "/img/6.jpg" "nav1"
        , navItem "bla" "#" "/img/4.jpg" "nav2"
        , navItem "bla" "#" "/img/5.jpg" "nav3"
        , navItem "bla" "#" "/img/4.jpg" "nav4"
        , navItem "bla" "#" "/img/5.jpg" "nav5"
        , navItem "bla" "#" "/img/6.jpg" "negate"
        ]
