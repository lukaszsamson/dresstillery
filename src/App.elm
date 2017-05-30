module App exposing (..)

import Css
import Html exposing (Html, a, button, div, h1, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Inc


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc ->
            (model + 1) ! []



-- VIEW
-- view : Model -> Html Msg


styles =
    Css.asPairs >> Html.Attributes.style


navItem caption link imageUrl className =
    div [ class className, class "navItem" ]
        [ a [ href link ]
            [ div [ class "imgContainer", style [ ( "background-image", "url(" ++ imageUrl ++ ")" ) ] ]
                [-- [ src imageUrl ] []
                ]
            , p
                []
                [ text caption ]
            ]
        ]


header =
    div [ class "header", style [ ( "background-image", "url(img/head.jpg)" ) ] ]
        [ h1 [] [ text "Wellcome in da shop" ]
        ]


mainContent =
    div []
        [ div [ class "content" ]
            [ navItem "trololo" "#" "img/1.jpg" "nav1"
            , navItem "bla" "#" "img/2.jpg" "nav2"
            , navItem "bla" "#" "img/3.jpg" "nav3"
            , navItem "bla" "#" "img/4.jpg" "nav4"
            , navItem "bla" "#" "img/5.jpg" "nav5"
            , navItem "bla" "#" "img/6.jpg" "nav6"
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ header
        , mainContent
        ]
