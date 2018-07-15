module Board exposing (..)

import Array exposing (Array)
import Array.Utils
import Cell exposing (Cell)
import Grid exposing (Grid, get)
import Random exposing (Generator, bool)


type alias Board =
    Grid Cell


isCellAlive : Cell -> Bool
isCellAlive cell =
    cell.alive


isEmpty : Board -> Bool
isEmpty board =
    not (hasLiveCells board)


randomBoard : Random.Seed -> Int -> Int -> Int -> ( Board, Random.Seed )
randomBoard seed rows cols probability =
    let
        randomAlive =
            Random.map (\c -> c <= probability) (Random.int 0 100)

        randomizeBoard =
            Random.list rows <| Random.list cols randomAlive

        ( randomVals, newSeed ) =
            Random.step randomizeBoard seed

        populateCell alive cell =
            { cell | alive = alive }

        populateRows randRow boardRow =
            List.map2 populateCell randRow boardRow

        newBoard =
            Grid.fromList <|
                List.map2 populateRows randomVals <|
                    Grid.toList (emptyBoard rows cols)
    in
    ( newBoard, newSeed )


hasLiveCells : Board -> Bool
hasLiveCells board =
    let
        rowHasLife row =
            Array.Utils.any isCellAlive row
    in
    Array.Utils.any rowHasLife board


getNeighbors : Int -> Int -> Board -> List Cell
getNeighbors x y board =
    let
        pairs =
            [ ( -1, -1 )
            , ( -1, 0 )
            , ( -1, 1 )
            , ( 0, 1 )
            , ( 1, 1 )
            , ( 1, 0 )
            , ( 1, -1 )
            , ( 0, -1 )
            ]

        findAdjacent ( x, y ) ( x1, y1 ) =
            get (x + x1) (y + y1) board
    in
    List.filterMap identity (List.map (findAdjacent ( x, y )) pairs)


countNeighbors : Int -> Int -> Board -> Int
countNeighbors x y board =
    List.length (List.filter (\c -> c.alive) (getNeighbors x y board))


emptyBoard : Int -> Int -> Board
emptyBoard numRows numCols =
    let
        cell =
            Cell False
    in
    Array.initialize numRows
        (\x -> Array.initialize numCols (\y -> cell))
