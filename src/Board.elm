module Board exposing (..)

import Array exposing (Array)
import Cell exposing (Cell, Coord)
import Array.Utils
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


getNeighbors : Cell -> Board -> List Cell
getNeighbors cell board =
    let
        pairs =
            [ (Coord -1 -1)
            , (Coord -1 0)
            , (Coord -1 1)
            , (Coord 0 1)
            , (Coord 1 1)
            , (Coord 1 0)
            , (Coord 1 -1)
            , (Coord 0 -1)
            ]

        findAdjacent cell coord =
            get (cell.coords.x + coord.x) (cell.coords.y + coord.y) board
    in
        List.filterMap identity (List.map (findAdjacent cell) pairs)


countNeighbors : Cell -> Board -> Int
countNeighbors cell board =
    List.length (List.filter (\c -> c.alive) (getNeighbors cell board))


emptyBoard : Int -> Int -> Board
emptyBoard numRows numCols =
    let
        cell x y =
            (Cell False (Coord x y))
    in
        Array.initialize numRows
            (\x -> (Array.initialize numCols (\y -> cell x y)))
