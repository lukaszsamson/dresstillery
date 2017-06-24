module BuyNow exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, src, type_)
import Html.Events exposing (onInput)
import Html.Keyed
import Models exposing (..)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)
import Routing exposing (Route, linkHref, onLinkClick)


type Msg
    = Load
    | ChangeLocation Route
    | FilterChange String
    | Loaded (WebData (List BuyNowItem))


type alias Model =
    { items : WebData (List BuyNowItem)
    , filterText : String
    , flags : Flags
    }


init : Flags -> Model
init flags =
    { items = RemoteData.NotAsked
    , filterText = ""
    , flags = flags
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Load ->
        --     ( model
        --     , if not model.loaded then
        --         delay (Time.second * 1) <| Loaded <| []
        --       else
        --         Cmd.none
        --     )
        Load ->
            ( { model | items = RemoteData.Loading, filterText = "" }, ProductsApi.fetchProducts model.flags Loaded )

        FilterChange filterText ->
            ( { model | filterText = filterText }, Cmd.none )

        Loaded response ->
            ( { model | items = response }, Cmd.none )

        ChangeLocation _ ->
            model ! []


item : BuyNowItem -> Html Msg
item item =
    let
        route =
            Routing.Product item.id
    in
    li [ class "buyNowItem" ]
        [ a [ linkHref route, onLinkClick (ChangeLocation route) ] [ img [ src item.src ] [] ]
        , div [ class "buyNowItemLabel" ]
            [ text item.label
            ]
        ]


itemFilter : String -> BuyNowItem -> Bool
itemFilter filterText item =
    let
        normalize =
            String.trim << String.toLower
    in
    normalize item.label |> String.contains (normalize filterText)


searchResults : List BuyNowItem -> String -> Html Msg
searchResults items filterText =
    let
        filtered =
            items
                |> List.filter (itemFilter <| filterText)

        message =
            if List.isEmpty filtered then
                [ div [ class "simpleMessage" ]
                    [ text "Brak wyników dla "
                    , Html.i
                        []
                        [ text filterText ]
                    , text "."
                    ]
                ]
            else
                []
    in
    div []
        (message
            ++ [ Html.Keyed.ul [ class "grid3", class "searchResults" ]
                    (filtered
                        |> List.map (\a -> ( toString a.id, item a ))
                    )
               ]
        )


maybeList : Model -> Html Msg
maybeList model =
    case model.items of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success items ->
            div []
                [ div [ class "buyNowSearch", class "grid3" ]
                    [ div [ class "centeredColumn" ]
                        [ input [ type_ "text", onInput FilterChange, placeholder "Szukaj" ] []
                        ]
                    ]
                , searchResults items model.filterText
                ]

        RemoteData.Failure error ->
            text (toString error)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Modele dostępne" ]
        , maybeList model
        ]
