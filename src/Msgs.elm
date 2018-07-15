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
    | IncreaseSpeed
    | DecreaseSpeed
    | ScrambleBoard
    | SetSeed Time
    | ClearBoard
    | UpdateProbability String
    | UpdateColsInput String
    | UpdateRowsInput String
    | ResizeBoard
