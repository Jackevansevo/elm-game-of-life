module Main exposing (..)

-- Project imports

import Html exposing (program)
import Keyboard
import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Task
import Time exposing (Time, every, millisecond, second)
import Update exposing (update)
import View exposing (view)


{- TODO:

   - Specify dimensions of board
-}


subscriptions : Model -> Sub Msg
subscriptions model =
    if not model.finished && model.playing then
        Sub.batch [ every model.speed Tick, Keyboard.downs KeyMsg ]
    else
        Keyboard.downs KeyMsg


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = ( initialModel, Task.perform Msgs.SetSeed Time.now )
        , update = update
        , subscriptions = subscriptions
        }
