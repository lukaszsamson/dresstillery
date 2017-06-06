module Routing exposing (..)

import Models exposing (Route(..))
import Navigation
import UrlParser


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Creator (UrlParser.s (pathImpl Creator))
        , UrlParser.map About (UrlParser.s (pathImpl About))
        , UrlParser.map FabricsAndAccesories (UrlParser.s (pathImpl FabricsAndAccesories))
        , UrlParser.map BuyNow (UrlParser.s (pathImpl BuyNow))
        , UrlParser.map Basket (UrlParser.s (pathImpl Basket))
        , UrlParser.map TermsAndConditions (UrlParser.s (pathImpl TermsAndConditions))
        , UrlParser.map Contact (UrlParser.s (pathImpl Contact))
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case UrlParser.parsePath matchers location of
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

        NotFound ->
            ""


path : Route -> String
path r =
    "/" ++ pathImpl r
