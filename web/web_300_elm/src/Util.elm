module Util exposing (..)

import Json.Encode as Enc exposing (..)
import Json.Decode as Dec exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Sha256 exposing (sha256, sha224)

import Model exposing (..)
import Model.Scene exposing (Enemy)
import Model.Geometry exposing (Vector)


eatStarMessage : Model -> String
eatStarMessage model =
    let
      message_ = "star_eat"
      t_ = model.gameTime
      sha = sha256 (message_ ++ (toString model.scene.player.score)  ++ (toString t_) ++ model.salt)
      mes_ = Enc.object [
        ("m", Enc.string message_),
        ("s", Enc.string (toString model.scene.player.score)),
        ("t", Enc.string (toString t_)),
        ("hash", Enc.string sha)]
    in
      Enc.encode 0 mes_


moveMessage : Model -> String
moveMessage model =
    let
      mes_ = Enc.object [
        ("m", Enc.string "move"),
        ("x", Enc.string (toString model.scene.player.position.x)),
        ("y", Enc.string (toString model.scene.player.position.y))]
    in
      Enc.encode 0 mes_


stringDecoder : String -> String -> Result String String
stringDecoder field_ message_ =
    Dec.decodeString (Dec.field field_ Dec.string) message_


getStarPosition : String -> Vector
getStarPosition message =
      message
        |> Dec.decodeString vectorDecoder
        |> Result.withDefault (Vector 0 0)


getEnemies : String -> List Enemy
getEnemies message =
    message
      |> Dec.decodeString (Dec.field "coords" (Dec.list enemyDecoder))
      |> Result.withDefault []


vectorDecoder : Decoder Enemy
vectorDecoder =
    Dec.map2 Vector
        (Dec.field "x" Dec.float)
        (Dec.field "y" Dec.float)


enemyDecoder : Decoder Enemy
enemyDecoder =
    Dec.map2 Enemy
        (Dec.field "x" Dec.float)
        (Dec.field "y" Dec.float)