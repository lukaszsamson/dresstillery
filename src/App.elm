module App exposing (..)

import Css
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Models exposing (..)
import Navigation
import Routing exposing (parseLocation, path)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( { model | changes = model.changes + 1 }, Navigation.newUrl path )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )



-- VIEW
-- view : Model -> Html Msg


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


navItem : String -> String -> String -> String -> Html msg
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


header : Html msg
header =
    div [ class "header", style [ ( "background-image", "url(img/head.jpg)" ) ] ]
        [ h1 [] [ text "Wellcome in da shop" ]
        ]


pageNotFound : Html msg
pageNotFound =
    div [] [ text "404" ]


creatorView : Html msg
creatorView =
    div [] [ text "creator" ]


homeView : Html msg
homeView =
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


mainContent : Model -> Html msg
mainContent model =
    case model.route of
        HomeRoute ->
            homeView

        CreatorRoute ->
            creatorView

        NotFoundRoute ->
            pageNotFound


{-| When clicking a link we want to prevent the default browser behaviour which is to load a new page.
So we use `onWithOptions` instead of `onClick`.
-}
onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    onWithOptions "click" options (Decode.succeed message)


menuLink : String -> String -> Html Msg
menuLink path label =
    li []
        [ a [ href path, onLinkClick (ChangeLocation path) ] [ text label ]
        ]


menu : Model -> Html Msg
menu model =
    div [ class "menu" ]
        [ menuLink (path HomeRoute) "Home"
        , menuLink (path CreatorRoute) "Creator"
        , text ("ch " ++ toString model.changes)
        ]


view : Model -> Html Msg
view model =
    div []
        [ header
        , menu model
        , mainContent model
        ]
