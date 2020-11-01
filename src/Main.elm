module Main exposing (..)

import Browser
import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Random
import Task
import Time exposing (every)
import Update exposing (update)
import View exposing (view)


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every model.speed Tick


init : Int -> ( Model, Cmd Msg )
init now =
    ( initialModel (Random.initialSeed now)
    , Cmd.none
    )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
