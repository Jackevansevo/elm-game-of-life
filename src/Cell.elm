module Cell exposing (..)


type alias Alive =
    Bool


type alias Cell =
    { alive : Alive }


nextState : Bool -> Int -> Alive
nextState alive neighbors =
    neighbors == 3 || (neighbors == 2 && alive)
