module Model exposing (..)

import Time exposing (Time)
import Set

import Model.Ui exposing (..)
import Model.Scene exposing (..)


type alias Model =
  { ui : Ui
  , scene : Scene
  , secondsPassed : Int
  , urlListen : String
  , urlSend : String
  , gameTime : Float
  , salt : String}


freshGame : Ui -> Model
freshGame ui =
  let
      ui_ = { ui | screen = PlayScreen
                 , pressedKeys = Set.empty }
  in
      { initialModel | ui = ui_ }

initialModel : Model
initialModel =
  { ui = initialUi
  , scene = initialScene
  , secondsPassed = 0
  , urlListen = "ws://193.218.139.202:1337"
  , urlSend = "ws://193.218.139.202:1337"
  , gameTime = 0
  , salt = "sdl4Df4(dsk!3sk*3saKha13SHA@fsl#" }
