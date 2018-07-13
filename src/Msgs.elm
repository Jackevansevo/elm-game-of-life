module Msgs exposing (..)

import Cell exposing (Cell)
import Keyboard
import Time exposing (Time)


type Msg
    = NoOp
    | ToggleCell Cell
    | NextState
    | PrevState
    | ResetGame
    | Tick Time
    | TogglePlaying
    | KeyMsg Keyboard.KeyCode
    | AlterSpeed Float
    | ScrambleBoard
    | SetSeed Time
    | ClearBoard
    | UpdateProbability String
    | UpdateCols String
    | UpdateRows String
    | UpdateSpeed String
