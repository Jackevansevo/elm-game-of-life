module Main exposing (..)

import Html exposing (program)
import Time exposing (Time, second, millisecond, every)
import Keyboard


-- Project imports

import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Update exposing (update)
import View exposing (view)
import Task


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
