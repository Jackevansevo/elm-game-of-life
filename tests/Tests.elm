module Tests exposing (..)

import Test exposing (..)
import Expect
import Cell exposing (Cell, Coord)


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


suite : Test
suite =
    describe "Test Suite"
        [ describe "Cell evolution rules"
            -- Nest as many descriptions as you like.
            [ test "Any live cell < 2 live neighbors dies" <|
                \_ ->
                    Expect.false "Expected cell to die." (Cell.nextState True 1)
            , test "Any live cell with 2 or 3 live neighbors lives" <|
                \_ ->
                    Expect.true "Expected all cells to live." <|
                        List.all identity
                            [ (Cell.nextState True 2), (Cell.nextState True 3) ]
            , test "Any live cell with > 3 live neighbors dies" <|
                \_ ->
                    Expect.false "Expected cell to die." (Cell.nextState True 4)
            , test "Any dead cell with exactly 3 live neighbors becomes a live cell" <|
                \_ ->
                    Expect.true "Expected cell to die." (Cell.nextState False 3)
            ]
        ]
