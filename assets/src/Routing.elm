module Routing exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (href)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | Creator
    | About
    | BuyNow
    | Product Int
    | ProductZoom Int Int
    | Basket
    | FabricsAndAccesories
    | TermsAndConditions
    | Contact
    | NotFound


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Creator (s (pathImpl Creator))
        , map About (s (pathImpl About))
        , map FabricsAndAccesories (s (pathImpl FabricsAndAccesories))
        , map BuyNow (s (pathImpl BuyNow))
        , map Product (s "products" </> int)
        , map ProductZoom (s "products" </> int </> s "images" </> int)
        , map Basket (s (pathImpl Basket))
        , map TermsAndConditions (s (pathImpl TermsAndConditions))
        , map Contact (s (pathImpl Contact))
        ]


parseLocation : Location -> Route
parseLocation location =
    case parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFound


pathImpl : Route -> String
pathImpl r =
    case r of
        Home ->
            ""

        About ->
            "about"

        Creator ->
            "creator"

        FabricsAndAccesories ->
            "fabrics_and_accesories"

        BuyNow ->
            "buy_now"

        Basket ->
            "basket"

        TermsAndConditions ->
            "terms_and_conditions"

        Contact ->
            "contact"

        Product i ->
            "products/" ++ toString i

        ProductZoom i j ->
            "products/" ++ toString i ++ "/images/" ++ toString j

        NotFound ->
            ""


toPath : Route -> String
toPath r =
    "/" ++ pathImpl r


{-| When clicking a link we want to prevent the default browser behaviour which is to load a new page.
So we use `onWithOptions` instead of `onClick`.
-}
onLinkClick : a -> Attribute a
onLinkClick msg =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    onWithOptions "click" options (Decode.succeed msg)


linkHref : Route -> Attribute a
linkHref route =
    href (toPath route)
