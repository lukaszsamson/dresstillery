module App exposing (..)

import BuyNowView
import Color exposing (Color)
import CreatorView
import Css
import FontAwesome
import Html exposing (Attribute, Html, a, button, div, h1, img, li, p, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Decode
import Messages exposing (..)
import Models exposing (..)
import Navigation
import Process
import Routing exposing (parseLocation, path)
import Task
import Time exposing (Time)


-- UPDATE


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BuyNowLoaded ->
            ( { model
                | buyNow =
                    { loaded = True
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
              }
            , Cmd.none
            )

        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        ToggleMenu ->
            ( { model | menuShown = not model.menuShown }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                newModel =
                    { model | route = newRoute }
            in
            newModel ! load newModel

        CreatorMessage msg_ ->
            updateCreator msg_ model


updateCreator : CreatorMsg -> Model -> ( Model, Cmd Msg )
updateCreator msg model =
    case msg of
        ColorPicked val ->
            let
                creator =
                    model.creator
            in
            ( { model
                | creator =
                    { creator | selectedColor = Just val }
              }
            , Cmd.none
            )

        LenghtChanged val ->
            let
                creator =
                    model.creator
            in
            ( { model
                | creator =
                    { creator | lenght = val }
              }
            , Cmd.none
            )


load : Model -> List (Cmd Msg)
load model =
    case model.route of
        Home ->
            []

        About ->
            []

        BuyNow ->
            if not model.buyNow.loaded then
                [ delay (Time.second * 5) <| BuyNowLoaded ]
            else
                []

        TermsAndConditions ->
            []

        FabricsAndAccesories ->
            []

        Contact ->
            []

        Creator ->
            []

        NotFound ->
            []



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
                [ class className ]
                [ text caption ]
            ]
        ]


header : Html msg
header =
    div [ class "header", style [ ( "background-image", "url(img/top.jpg)" ) ] ]
        []


pageNotFound : Html msg
pageNotFound =
    div [ class "content" ] [ text "404" ]


aboutView : Html msg
aboutView =
    div [ class "content" ] [ text "about" ]


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
        , navItem "bla" "#" "img/6.jpg" "negate"
        ]


mainContent : Model -> Html Msg
mainContent model =
    case model.route of
        Home ->
            homeView

        About ->
            aboutView

        BuyNow ->
            BuyNowView.view model

        TermsAndConditions ->
            termsAndConditionsView

        FabricsAndAccesories ->
            fabricsAndAccesoriesView

        Contact ->
            contactView

        Creator ->
            CreatorView.view model

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


menuContainer : Model -> Html Msg
menuContainer model =
    div
        [ class
            (if model.menuShown then
                "menuShown"
             else
                ""
            )
        ]
        [ menu model
        , div [ class "menuIcon", onClick ToggleMenu ] [ FontAwesome.bars (Color.rgb 0 0 0) 60 ]
        ]


menu : Model -> Html Msg
menu model =
    div [ class "menu" ]
        [ div [ class "menuClose", onClick ToggleMenu ] [ FontAwesome.close (Color.rgb 0 0 0) 10 ]
        , div [ class "logo" ] [ img [ src "img/logo.png" ] [] ]
        , ul []
            [ menuLink (path Home) "Home"
            , menuLink (path About) "Kim jesteśmy"
            , menuLink (path BuyNow) "Kup teraz"
            , menuLink (path Creator) "Zaprojektuj własną spódnicę"
            , menuLink (path FabricsAndAccesories) "Tkaniny i akcesoria"
            , menuLink (path TermsAndConditions) "Warunki zakupów"
            ]
        , div [ class "social" ]
            [ FontAwesome.instagram (Color.rgb 0 0 0) 60
            , FontAwesome.facebook_official (Color.rgb 0 0 0) 60
            , FontAwesome.twitter (Color.rgb 0 0 0) 60
            ]
        ]


footer : Html Msg
footer =
    div [ class "footer" ]
        [ p [] [ text "Copyright Ⓒ ja" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ header
        , menuContainer model
        , mainContent model
        , footer
        ]
