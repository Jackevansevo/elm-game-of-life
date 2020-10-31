module Msgs exposing (..)

import Cell exposing (Cell)


type Msg
    = NoOp
    | ToggleCell Int Int
    | NextState
    | PrevState
    | ResetGame
    | Tick Int
    | TogglePlaying
    | IncreaseSpeed
    | DecreaseSpeed
    | ScrambleBoard
    | SetSeed Int
    | ClearBoard
    | UpdateProbability String
    | UpdateColsInput String
    | UpdateRowsInput String
    | ResizeBoard
