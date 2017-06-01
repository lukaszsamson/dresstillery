module Routing exposing (..)

import Models exposing (Route(..))
import Navigation
import UrlParser


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute UrlParser.top
        , UrlParser.map CreatorRoute (UrlParser.s "creator")
        ]


parseLocation : Navigation.Location -> Route
parseLocation location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


path : Route -> String
path r =
    case r of
        HomeRoute ->
            "/"

        CreatorRoute ->
            "/creator"

        NotFoundRoute ->
            "/"
