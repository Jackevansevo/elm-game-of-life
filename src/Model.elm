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


initialModel : Random.Seed -> Model
initialModel initialSeed =
    let
        ( rows, cols ) =
            ( 50, 50 )

        probability =
            20

        ( randomBoard, seed ) =
            Board.randomBoard initialSeed rows cols probability
    in
    { board = randomBoard
    , rows = rows
    , cols = cols
    , rowInput = String.fromInt rows
    , colInput = String.fromInt cols
    , playing = False
    , finished = False
    , history = Array.empty
    , generation = 0
    , debug = False
    , speed = 1000
    , seed = seed
    , probability = probability
    }
