module Model exposing (..)

import Array exposing (Array)
import Board exposing (Board)
import Random


type alias Model =
    { board : Board
    , rows : Int
    , cols : Int
    , rowInput : String
    , colInput : String
    , playing : Bool
    , finished : Bool
    , history : Array Board
    , generation : Int
    , debug : Bool
    , speed : Float
    , seed : Random.Seed
    , probability : Int
    }


initialModel : Model
initialModel =
    let
        ( rows, cols ) =
            ( 50, 50 )
    in
    { board = Board.emptyBoard rows cols
    , rows = rows
    , cols = cols
    , rowInput = "50"
    , colInput = "50"
    , playing = False
    , finished = False
    , history = Array.empty
    , generation = 0
    , debug = False
    , speed = 1
    , seed = Random.initialSeed 0
    , probability = 20
    }
