module Cell exposing (..)


type alias Coord =
    { x : Int, y : Int }


type alias Alive =
    Bool


type alias Cell =
    { alive : Alive
    , coords : Coord
    }


nextState : Bool -> Int -> Alive
nextState alive neighbors =
    neighbors == 3 || (neighbors == 2 && alive)
