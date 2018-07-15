module Update exposing (..)

-- Project imports

import Array exposing (Array)
import Array.Utils exposing (butLast, last)
import Board exposing (Board)
import Cell exposing (Cell)
import Grid exposing (get, map, set)
import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Random
import Time exposing (second)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSeed time ->
            ( { model | seed = Random.initialSeed (round time) }, Cmd.none )

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
                    Result.withDefault 10 <| String.toInt model.colInput

                newRows =
                    Result.withDefault 10 <| String.toInt model.rowInput
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
                    String.toInt val |> Result.toMaybe |> Maybe.withDefault 20
            in
            ( { model | probability = newProbability }, Cmd.none )

        TogglePlaying ->
            ( { model | playing = not model.playing }, Cmd.none )

        ResetGame ->
            ( initialModel, Cmd.none )

        ClearBoard ->
            ( { model
                | board = Board.emptyBoard model.rows model.cols
                , playing = False
              }
            , Cmd.none
            )

        ToggleCell cell ->
            let
                newCell =
                    { cell | alive = not cell.alive }

                newBoard =
                    Grid.set cell.coords.x cell.coords.y newCell model.board
            in
            ( { model
                | board = newBoard
                , playing = False
                , finished = False
              }
            , Cmd.none
            )

        IncreaseSpeed ->
            let
                redrawFrequency =
                    second / model.speed

                nextIncrement =
                    case redrawFrequency of
                        1 ->
                            2.5

                        10 ->
                            25

                        200 ->
                            200

                        _ ->
                            redrawFrequency * 2
            in
            ( { model | speed = second / nextIncrement }, Cmd.none )

        DecreaseSpeed ->
            let
                redrawFrequency =
                    second / model.speed

                nextIncrement =
                    case redrawFrequency of
                        2.5 ->
                            1

                        25 ->
                            10

                        0.25 ->
                            0.25

                        _ ->
                            redrawFrequency / 2
            in
            ( { model | speed = second / nextIncrement }, Cmd.none )

        NextState ->
            let
                updateCell cell =
                    let
                        liveNeighbors =
                            Board.countNeighbors cell model.board
                    in
                    { cell | alive = Cell.nextState cell.alive liveNeighbors }

                newBoard =
                    Grid.map updateCell model.board
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
                Just prevBoard ->
                    ( { model
                        | board = prevBoard
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

        KeyMsg code ->
            case code of
                32 ->
                    update TogglePlaying model

                39 ->
                    update NextState model

                37 ->
                    update PrevState model

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
