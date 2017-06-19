module Utils exposing (..)

import Process
import Task
import Time exposing (Time)


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


updateComponent : (msg -> model -> ( model, Cmd msg )) -> (msg -> parentMsg) -> msg -> model -> (model -> parentModel) -> ( parentModel, Cmd parentMsg )
updateComponent componentUpdate wrapper componentMessage componentModel updateModel =
    let
        ( componentModel_, componentCommand ) =
            componentUpdate componentMessage componentModel

        wrappedCommand =
            Cmd.map (\a -> wrapper a) componentCommand
    in
    ( updateModel componentModel_, wrappedCommand )


updateParent : (parentModel -> ( parentModel, Cmd parentMsg )) -> ( parentModel, Cmd parentMsg ) -> ( parentModel, Cmd parentMsg )
updateParent parentUpdate ( model, command ) =
    let
        ( model_, command_ ) =
            parentUpdate model
    in
    ( model_, Cmd.batch [ command, command_ ] )


loremIpsum : String
loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque quis finibus diam. Nunc dolor purus, vehicula vitae sollicitudin sed, venenatis ut nulla. Etiam scelerisque eros ipsum, euismod molestie lacus interdum eu. Fusce luctus id arcu quis congue. Aenean eros odio, maximus eget consequat vel, gravida sit amet magna. Phasellus efficitur augue vel urna pellentesque, non lacinia est pulvinar. Maecenas at viverra ligula. Praesent quis quam feugiat, vehicula massa et, feugiat enim. Fusce nulla massa, imperdiet in tellus nec, hendrerit fringilla est. Aliquam nec faucibus felis, in convallis nisi. Nunc faucibus pharetra nulla sit amet efficitur. Etiam varius faucibus nibh, id gravida neque consectetur et. Nunc aliquam magna ac lectus egestas, eu pretium ante ullamcorper. Sed dignissim lacus sit amet urna pharetra, non tincidunt sapien efficitur. Maecenas a tempus erat, sit amet suscipit leo. Donec placerat orci eu lectus semper faucibus.\n"


productText : String
productText =
    "Spódnica uszyta jest z wysokiej jakości dzianiny.\n\nWzór tkaniny to piękny, kwiatowy print włoskiego projektu.\n\nSpódnica jest mocno rozkloszowana,\nuszyta jest z pełnego koła\ni ma modną długość midi.\n\nSpódniczka posiada podszewkę.\nZapinana jest z tyłu na kryty zamek.\n\nSpódnica posiada wygodne\ni funkcjonalne kieszenie.\n\nPRODUKT POLSKI"
