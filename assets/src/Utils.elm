module Utils exposing (..)

import Html exposing (Html)
import Process
import Task
import Time exposing (Time)


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


type alias Component modelP msgP modelC msgC =
    { getter : modelP -> modelC
    , setter : modelP -> modelC -> modelP
    , update : msgC -> modelC -> ( modelC, Cmd msgC )
    , view : modelC -> Html msgC
    , wrap : msgC -> msgP
    }


updateComponent :
    Component a msgP modelC b
    -> a
    -> b
    -> Maybe c
    -> (c -> a -> ( a, Cmd msgP ))
    -> ( a, Cmd msgP )
updateComponent c m msg pmsg uv =
    let
        ( m_, cmd ) =
            updateComponent_ c msg m
    in
    case pmsg of
        Nothing ->
            ( m_, cmd )

        Just v ->
            let
                ( m__, cmd_ ) =
                    uv v m_
            in
            ( m__, Cmd.batch [ cmd, cmd_ ] )


updateComponent_ : Component modelP msgP modelC msgC -> msgC -> modelP -> ( modelP, Cmd msgP )
updateComponent_ c componentMessage model =
    let
        ( componentModel_, componentCommand ) =
            c.update componentMessage (c.getter model)

        wrappedCommand =
            Cmd.map c.wrap componentCommand
    in
    ( c.setter model componentModel_, wrappedCommand )


subView : Component a b aa bb -> a -> Html b
subView c m =
    c.view (c.getter m)
        |> Html.map c.wrap


wrap : (a -> b -> c) -> (a -> b) -> a -> c
wrap msg toParent =
    \m -> msg m (toParent m)


loremIpsum : String
loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque quis finibus diam. Nunc dolor purus, vehicula vitae sollicitudin sed, venenatis ut nulla. Etiam scelerisque eros ipsum, euismod molestie lacus interdum eu. Fusce luctus id arcu quis congue. Aenean eros odio, maximus eget consequat vel, gravida sit amet magna. Phasellus efficitur augue vel urna pellentesque, non lacinia est pulvinar. Maecenas at viverra ligula. Praesent quis quam feugiat, vehicula massa et, feugiat enim. Fusce nulla massa, imperdiet in tellus nec, hendrerit fringilla est. Aliquam nec faucibus felis, in convallis nisi. Nunc faucibus pharetra nulla sit amet efficitur. Etiam varius faucibus nibh, id gravida neque consectetur et. Nunc aliquam magna ac lectus egestas, eu pretium ante ullamcorper. Sed dignissim lacus sit amet urna pharetra, non tincidunt sapien efficitur. Maecenas a tempus erat, sit amet suscipit leo. Donec placerat orci eu lectus semper faucibus.\n"
