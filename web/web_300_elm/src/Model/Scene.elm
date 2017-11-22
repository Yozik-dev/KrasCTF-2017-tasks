module Model.Scene exposing (..)

import Keyboard exposing (KeyCode)
import Char exposing (toCode)
import Time exposing (Time)

import Model.Geometry exposing (..)

type alias Scene =
  { player : Player
  , star : Star
  , enemies: List Enemy}

type alias Player =
  { score : Int
  , leftKey : KeyCode
  , rightKey : KeyCode
  , upKey : KeyCode
  , downKey : KeyCode
  , position : Vector
  , velocity : Vector }

type alias Star =
  { position: Vector }

type alias Enemy =
  { x: Float
  , y: Float }


initialScene : Scene
initialScene =
  { player = createPlayer 'A' 'D' 'W' 'S'
  , star = createStar
  , enemies = [] }


createPlayer : Char -> Char -> Char -> Char -> Player
createPlayer leftKey rightKey upKey downKey =
  { score = 0
  , leftKey = Char.toCode leftKey
  , rightKey = Char.toCode rightKey
  , upKey = Char.toCode upKey
  , downKey = Char.toCode downKey
  , position = { x = 100, y = 100 }
  , velocity = { x = 0, y = 0 }}


createStar : Star
createStar =
    { position = { x = 200, y = 200 }}


playerRadius : Float
playerRadius = 10

starRadius : Float
starRadius = 3