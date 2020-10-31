module Grid exposing (..)

import Array exposing (Array)


type alias Grid a =
    Array (Array a)


get : Int -> Int -> Grid a -> Maybe a
get x y board =
    case Array.get x board of
        Just row ->
            Array.get y row

        Nothing ->
            Nothing


set : Int -> Int -> a -> Grid a -> Grid a
set x y val board =
    let
        row =
            Array.get x board
    in
    case row of
        Just thisRow ->
            let
                newRow =
                    Array.set y val thisRow
            in
            Array.set x newRow board

        Nothing ->
            board


map : (a -> b) -> Grid a -> Grid b
map fn grid =
    Array.map (\x -> Array.map fn x) grid


indexedMap : (Int -> Int -> a -> b) -> Grid a -> Grid b
indexedMap fn grid =
    Array.indexedMap
        (\rowIndex row ->
            Array.indexedMap
                (\colIndex cell -> fn rowIndex colIndex cell)
                row
        )
        grid


toList : Grid a -> List (List a)
toList grid =
    Array.toList (Array.map Array.toList grid)


fromList : List (List a) -> Grid a
fromList list =
    Array.fromList (List.map Array.fromList list)
