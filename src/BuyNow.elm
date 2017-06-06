module BuyNow exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time
import Utils exposing (delay)


type Msg
    = Load
    | Loaded


type alias Item =
    { label : String
    , src : String
    }


type alias Model =
    { loaded : Bool
    , items : List Item
    }


init : Model
init =
    { loaded = False
    , items = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model
            , if not model.loaded then
                delay (Time.second * 5) <| Loaded
              else
                Cmd.none
            )

        Loaded ->
            { model
                | loaded = True
                , items =
                    [ { label = "ksadf sadffsd df", src = "img/cat/1.jpg" }
                    , { label = "sdfdf", src = "img/cat/2.jpg" }
                    , { label = "dsd few", src = "img/cat/3.jpg" }
                    , { label = "erffre re", src = "img/cat/4.jpg" }
                    , { label = "sdcd dcscerf", src = "img/cat/5.jpg" }
                    , { label = "fer erf", src = "img/cat/6.jpg" }
                    , { label = "rfrt gtef", src = "img/cat/7.jpg" }
                    ]
            }
                ! []


item : Item -> Html Msg
item item =
    div []
        [ div [] [ img [ src item.src ] [] ]
        , div []
            [ text item.label
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ if model.loaded then
            div [] (List.map item model.items)
          else
            div [] [ text "Loading" ]
        ]
