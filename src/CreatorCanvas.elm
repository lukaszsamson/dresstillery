module CreatorCanvas exposing (..)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)


creatorCanvas : Int -> String -> Html.Html msg
creatorCanvas len color =
    let
        bottom =
            len + 100
    in
    svg
        [ version "1.1"
        , x "0"
        , y "0"
        , viewBox "0 0 320 320"
        ]
        [ polygon [ fill color, points ("100,100 200,100 230," ++ toString bottom ++ " 70," ++ toString bottom) ] []
        , polygon [ fill "#000000", points "100,90 200,90 200,100 100,100" ] []
        ]
