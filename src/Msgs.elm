module Msgs exposing (..)

import Cell exposing (Cell)
import Time


type Msg
    = NoOp
    | ToggleCell Int Int
    | NextState
    | PrevState
    | ResetGame
    | Tick Time.Posix
    | TogglePlaying
    | IncreaseSpeed
    | DecreaseSpeed
    | ScrambleBoard
    | ClearBoard
    | UpdateProbability String
    | UpdateColsInput String
    | UpdateRowsInput String
    | ResizeBoard
