module App exposing (..)

import Color exposing (Color)
import Css
import FontAwesome
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
    div [ class "content" ] [ text "404" ]


creatorView : Html msg
creatorView =
    div [ class "content" ] [ text "creator" ]


aboutView : Html msg
aboutView =
    div [ class "content" ] [ text "about" ]


buyNowView : Html msg
buyNowView =
    div [ class "content" ] [ text "buyNow" ]


termsAndConditionsView : Html msg
termsAndConditionsView =
    div [ class "content" ] [ text "termsAndConditions" ]


fabricsAndAccesoriesView : Html msg
fabricsAndAccesoriesView =
    div [ class "content" ] [ text "fabricsAndAccesories" ]


contactView : Html msg
contactView =
    div [ class "content" ] [ text "contact" ]


homeView : Html msg
homeView =
    div [ class "content" ]
        [ navItem "trololo" "#" "img/1.jpg" "nav1"
        , navItem "bla" "#" "img/2.jpg" "nav2"
        , navItem "bla" "#" "img/3.jpg" "nav3"
        , navItem "bla" "#" "img/4.jpg" "nav4"
        , navItem "bla" "#" "img/5.jpg" "nav5"
        , navItem "bla" "#" "img/6.jpg" "nav6"
        ]


mainContent : Model -> Html msg
mainContent model =
    case model.route of
        Home ->
            homeView

        About ->
            aboutView

        BuyNow ->
            buyNowView

        TermsAndConditions ->
            termsAndConditionsView

        FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Contact ->
            contactView

        Creator ->
            creatorView

        NotFound ->
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
        [ img [ class "logo", src "img/logo.png" ] []
        , ul []
            [ menuLink (path Home) "Home"
            , menuLink (path About) "Kim jesteśmy"
            , menuLink (path BuyNow) "Kup teraz"
            , menuLink (path Creator) "Zaprojektuj własną spódnicę"
            , menuLink (path FabricsAndAccesories) "Tkaniny i akcesoria"
            , menuLink (path TermsAndConditions) "Warunki zakupów"
            , text ("" ++ toString model.changes)
            ]
        , div [ class "social" ]
            [ FontAwesome.instagram (Color.rgb 0 0 0) 60
            , FontAwesome.facebook_official (Color.rgb 0 0 0) 60
            , FontAwesome.twitter (Color.rgb 0 0 0) 60
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ header
        , menu model
        , mainContent model
        ]
