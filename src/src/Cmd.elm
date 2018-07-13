module Cmd exposing (..)

import Random


shuffleBoard : Board -> Cmd Msg
shuffleBoard board =
    Random.Generate bool <| Random.list 5
