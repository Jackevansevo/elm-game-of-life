module View exposing (..)

import Array exposing (Array)
import Board
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Msgs exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes


playPauseBtn : Model -> Html Msg
playPauseBtn model =
    let
        isDisabled =
            model.finished || not (Board.hasLiveCells model.board)

        btnClass =
            if model.playing then
                "btn btn-danger btn-lg"
            else
                "btn btn-success btn-lg"

        btnTitle =
            if model.playing then
                "Pause"
            else
                "Pause"

        btnIcon =
            if model.playing then
                "fas fa-pause"
            else
                "fas fa-play"
    in
    button
        [ type_ "btn"
        , class btnClass
        , onClick TogglePlaying
        , disabled isDisabled
        , title btnTitle
        ]
        [ i [ class btnIcon ] [] ]


gameOverMsg : Html Msg
gameOverMsg =
    div [ class "jumbotron" ]
        [ div [ class "container" ]
            [ h1 [ class "display-4 text-danger" ] [ text "Game Over" ]
            , hr [ class "my-4" ] []
            , resetBtn
            ]
        ]


nextStateBtn : Model -> Html Msg
nextStateBtn model =
    let
        isDisabled =
            model.playing || model.finished || Board.isEmpty model.board
    in
    button
        [ type_ "button"
        , class "btn btn-lg btn-light"
        , onClick NextState
        , disabled isDisabled
        , title "Next State"
        ]
        [ i [ class "fas fa-step-forward" ] [] ]


previousStateBtn : Model -> Html Msg
previousStateBtn model =
    let
        isDisabled =
            model.generation == 0 || model.playing
    in
    button
        [ type_ "button"
        , class "btn btn-lg btn-light"
        , onClick PrevState
        , disabled isDisabled
        , title "Previous State"
        ]
        [ i [ class "fas fa-step-backward" ] [] ]


increaseSpeedBtn : Model -> Html Msg
increaseSpeedBtn model =
    button
        [ type_ "button"
        , class "btn btn-lg btn-light"
        , onClick IncreaseSpeed
        , title "Increase Speed"
        ]
        [ i [ class "fas fa-fast-forward" ] [] ]


decreaseSpeedBtn : Model -> Html Msg
decreaseSpeedBtn model =
    button
        [ type_ "button"
        , class "btn btn-lg btn-light"
        , onClick DecreaseSpeed
        , title "Decrease Speed"
        ]
        [ i [ class "fas fa-fast-backward" ] [] ]


scrambleBtn : Model -> Html Msg
scrambleBtn model =
    button
        [ type_ "button"
        , class "btn btn-info btn-block"
        , onClick ScrambleBoard
        , title "Scramble Board"
        ]
        [ i [ class "fas fa-random pr-2" ] [], text "Scramble" ]


clearBoardBtn : Html Msg
clearBoardBtn =
    button
        [ type_ "button"
        , class "btn btn-danger btn-block"
        , onClick ClearBoard
        , title "Clear Board"
        ]
        [ i [ class "fas fa-th pr-2" ] [], text "Clear" ]


resetBtn : Html Msg
resetBtn =
    button
        [ type_ "button"
        , class "btn btn-warning btn-block"
        , onClick ResetGame
        , title "Reset Game"
        ]
        [ i [ class "fas fa-undo pr-2" ] [], text "Reset" ]


infoSection : Model -> Html Msg
infoSection model =
    ul [ class "list-group my-1" ]
        [ li [ class "list-group-item d-flex justify-content-between align-items-center list-group-item-action" ]
            [ text "Speed"
            , span [ class "badge badge-secondary badge-pill" ]
                [ text "wew" ]
            ]
        , li [ class "list-group-item d-flex justify-content-between align-items-center list-group-item-action" ]
            [ text "Generation"
            , span [ class "badge badge-secondary badge-pill" ]
                [ text (String.fromInt model.generation) ]
            ]
        ]


resizeBoardForm : Model -> Html Msg
resizeBoardForm model =
    div [ class "card card-body my-1 pt-1 pb-2" ]
        [ Html.form []
            [ div [ class "form-row" ]
                [ div [ class "form-group col-md-6" ]
                    [ label [ class "col-form-label" ] [ text "Columns" ]
                    , input
                        [ class "form-control col"
                        , type_ "number"
                        , value model.colInput
                        , onInput UpdateColsInput
                        ]
                        []
                    ]
                , div [ class "form-group col-md-6" ]
                    [ label [ class "col-form-label" ] [ text "Rows" ]
                    , input
                        [ class "form-control"
                        , type_ "number"
                        , value model.rowInput
                        , onInput UpdateRowsInput
                        ]
                        []
                    ]
                ]
            , button
                [ type_ "button"
                , class "btn btn-success btn-block"
                , onClick ResizeBoard
                , title "Resize"
                ]
                [ i [ class "fas fa-expand pr-2" ] [], text "Resize" ]
            ]
        ]


scrambleBoardForm : Model -> Html Msg
scrambleBoardForm model =
    div [ class "card card-body my-1 py-2" ]
        [ div [ class "form-group" ]
            [ label [] [ text "Probability" ]
            , input
                [ onInput UpdateProbability
                , class "custom-range"
                , type_ "range"
                , Html.Attributes.min "10"
                , Html.Attributes.max "80"
                , Html.Attributes.step "5"
                ]
                []
            ]
        , scrambleBtn model
        ]


boardControlButtons : Html Msg
boardControlButtons =
    div [ class "my-1" ]
        [ clearBoardBtn
        , resetBtn
        ]


speedControlButtons : Model -> Html Msg
speedControlButtons model =
    div [ class "card card-body my-1" ]
        [ div [ class "row justify-content-around" ]
            [ decreaseSpeedBtn model
            , previousStateBtn model
            , playPauseBtn model
            , nextStateBtn model
            , increaseSpeedBtn model
            ]
        ]


boardControls : Model -> Html Msg
boardControls model =
    div
        [ class "col-lg-3 col-md-6 col-sm-12 bg-light"
        , style "height" "100vh"
        ]
        [ div [ class "d-flex flex-column align-items-stretch justify-content-start thing" ]
            [ speedControlButtons model
            , scrambleBoardForm model
            , resizeBoardForm model
            , infoSection model
            , boardControlButtons
            ]
        ]


view : Model -> Html Msg
view model =
    let
        ( xDimension, yDimension ) =
            ( model.cols * 10 |> String.fromInt, model.rows * 10 |> String.fromInt )

        drawCell rowIndex colIndex cell =
            let
                cellStyle =
                    if cell.alive then
                        "#17a2b8"
                    else
                        "#fff"
            in
            rect
                [ Svg.Attributes.x (String.fromInt (colIndex * 10))
                , Svg.Attributes.y (String.fromInt (rowIndex * 10))
                , Svg.Attributes.width "10"
                , Svg.Attributes.height "10"
                , Svg.Attributes.fill cellStyle
                , Svg.Attributes.stroke "#34495e"
                , onClick (ToggleCell rowIndex colIndex)
                ]
                []

        drawRow rowIndex cells =
            Array.toList (Array.indexedMap (drawCell rowIndex) cells)

        board =
            if model.finished then
                div [ class "col-lg-9 col-md-6 col-sm-12 d-flex justify-content-center flex-column" ]
                    [ gameOverMsg ]
            else
                div [ class "col-lg-9 col-md-6 col-sm-12 board-container" ]
                    [ svg
                        [ Svg.Attributes.width xDimension
                        , Svg.Attributes.height yDimension
                        ]
                        (List.concat (Array.toList (Array.indexedMap drawRow model.board)))
                    ]
    in
    div [ class "container-fluid bg-succes", style "height" "100vh" ]
        [ div [ class "row" ]
            [ boardControls model
            , board
            ]
        ]
