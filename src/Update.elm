module Update exposing (..)

import Array exposing (push)
import Array.Utils exposing (butLast, last)
import Board exposing (Board)
import Cell exposing (Cell)
import Grid exposing (get, map, set)
import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Random
import Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            if model.playing then
                update NextState model

            else
                ( model, Cmd.none )

        UpdateColsInput val ->
            ( { model | colInput = val }, Cmd.none )

        UpdateRowsInput val ->
            ( { model | rowInput = val }, Cmd.none )

        ResizeBoard ->
            let
                newCols =
                    Maybe.withDefault 10 (String.toInt model.colInput)

                newRows =
                    Maybe.withDefault 10 (String.toInt model.rowInput)
            in
            ( { model
                | board = Board.emptyBoard newCols newRows
                , cols = newCols
                , rows = newRows
              }
            , Cmd.none
            )

        UpdateProbability val ->
            let
                newProbability =
                    Maybe.withDefault 10 (String.toInt val)
            in
            ( { model | probability = newProbability }, Cmd.none )

        TogglePlaying ->
            ( { model | playing = not model.playing }, Cmd.none )

        ResetGame ->
            ( initialModel (Random.initialSeed 0), Cmd.none )

        ClearBoard ->
            ( { model
                | board = Board.emptyBoard model.rows model.cols
                , playing = False
              }
            , Cmd.none
            )

        ToggleCell x y ->
            case Grid.get x y model.board of
                Just cell ->
                    let
                        newCell =
                            { cell | alive = not cell.alive }

                        newBoard =
                            Grid.set x y newCell model.board
                    in
                    ( { model
                        | board = newBoard
                        , playing = False
                        , finished = False
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        IncreaseSpeed ->
            if model.speed == 1000 then
                ( { model | speed = 500 }, Cmd.none )

            else if model.speed == 500 then
                ( { model | speed = 250 }, Cmd.none )

            else
                ( model, Cmd.none )

        DecreaseSpeed ->
            if model.speed == 250 then
                ( { model | speed = 500 }, Cmd.none )

            else if model.speed == 500 then
                ( { model | speed = 1000 }, Cmd.none )

            else
                ( model, Cmd.none )

        NextState ->
            let
                updateCell x y cell =
                    let
                        liveNeighbors =
                            Board.countNeighbors x y model.board
                    in
                    { cell | alive = Cell.nextState cell.alive liveNeighbors }

                newBoard =
                    Grid.indexedMap updateCell model.board
            in
            if model.board == newBoard || Board.isEmpty newBoard then
                ( { model
                    | board = newBoard
                    , history = Array.push model.board model.history
                    , generation = model.generation + 1
                    , finished = True
                    , playing = False
                  }
                , Cmd.none
                )

            else
                ( { model
                    | board = newBoard
                    , history = Array.push model.board model.history
                    , generation = model.generation + 1
                  }
                , Cmd.none
                )

        PrevState ->
            let
                ( newHistory, prevBoard ) =
                    Array.Utils.pop model.history
            in
            case prevBoard of
                Just board ->
                    ( { model
                        | board = board
                        , history = newHistory
                        , generation = model.generation - 1
                        , finished = False
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        ScrambleBoard ->
            let
                ( newBoard, newSeed ) =
                    Board.randomBoard model.seed model.rows model.cols model.probability
            in
            ( { model
                | board = newBoard
                , seed = newSeed
                , generation = 0
                , finished = False
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
