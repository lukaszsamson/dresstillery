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
