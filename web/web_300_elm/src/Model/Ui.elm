module Model.Ui exposing (..)

import Set exposing (Set)
import Keyboard exposing (KeyCode)

import Model.Scene exposing (..)


type alias Ui =
  { windowSize : (Int, Int)
  , pressedKeys : Set KeyCode
  , screen : Screen
  , winMessage : String }


type Screen = StartScreen | PlayScreen | WinScreen

initialUi : Ui
initialUi =
  { windowSize = (600,400)
  , pressedKeys = Set.empty
  , screen = StartScreen
  , winMessage = "" }


keyPressed : KeyCode -> Set KeyCode -> Bool
keyPressed keycode pressedKeys =
  Set.member keycode pressedKeys
