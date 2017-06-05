module Utils exposing (..)

import Process
import Task
import Time exposing (Time)


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
