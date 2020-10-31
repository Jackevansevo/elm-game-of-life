module Main exposing (..)

import Browser
import Model exposing (Model, initialModel)
import Msgs exposing (..)
import Task
import Time exposing (every)
import Update exposing (update)
import View exposing (view)


subscriptions : Model -> Sub Msg
subscriptions model =
        Sub.none

init : () -> (Model, Cmd Msg)
init _ =
  ( initialModel
  , Cmd.none
  )

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
