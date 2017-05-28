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
    div [ class className ]
        [ a [ href link ]
            [ img [ src imageUrl, styles [ Css.width (Css.pct 100) ] ] []
            , p [] [ text caption ]
            ]
        ]


mainContent =
    div [ styles [ Css.marginTop (Css.px 100) ] ]
        [ h1
            [ styles
                [ Css.backgroundColor (Css.rgb 74 153 120)
                , Css.height (Css.px 250)
                ]
            ]
            [ text "Wellcome in da shop" ]
        , div [ class "content" ]
            [ navItem "trololo" "#" "img/1.jpg" "nav1"
            , navItem "bla" "#" "img/2.jpg" "nav2"
            , navItem "bla" "#" "img/3.jpg" "nav3"
            , navItem "bla" "#" "img/4.jpg" "nav4"
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ mainContent
        ]
