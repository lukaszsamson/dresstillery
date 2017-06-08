module BuyNow exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ProductModels exposing (..)
import Routing exposing (Route, linkHref, onLinkClick)
import Time
import Utils exposing (delay)


type Msg
    = Load
    | ChangeLocation Route
    | Loaded (List BuyNowItem)


type alias Model =
    { loaded : Bool
    , items : List BuyNowItem
    }


init : Model
init =
    { loaded = False
    , items = []
    }


mockItems : List BuyNowItem
mockItems =
    [ { id = 1, label = "ksadf sadffsd df", src = "/img/cat/1.jpg" }
    , { id = 2, label = "sdfdf", src = "/img/cat/2.jpg" }
    , { id = 3, label = "dsd few", src = "/img/cat/3.jpg" }
    , { id = 4, label = "erffre re", src = "/img/cat/4.jpg" }
    , { id = 5, label = "sdcd dcscerf", src = "/img/cat/5.jpg" }
    , { id = 6, label = "fer erf", src = "/img/cat/6.jpg" }
    , { id = 7, label = "rfrt gtef", src = "/img/cat/7.jpg" }
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model
            , if not model.loaded then
                delay (Time.second * 1) <| Loaded <| mockItems
              else
                Cmd.none
            )

        Loaded items ->
            { model
                | loaded = True
                , items = items
            }
                ! []

        ChangeLocation _ ->
            model ! []


item : BuyNowItem -> Html Msg
item item =
    let
        route =
            Routing.Product item.id
    in
    div [ class "buyNowItem" ]
        [ a [ linkHref route, onLinkClick (ChangeLocation route) ] [ img [ src item.src ] [] ]
        , div []
            [ text item.label
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        (if model.loaded then
            List.map item model.items
         else
            [ text "Loading" ]
        )
