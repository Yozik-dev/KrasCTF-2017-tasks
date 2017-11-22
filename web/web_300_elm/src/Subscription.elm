module Subscription exposing (..)

import Time exposing (Time,second)

import Model exposing (..)
import Model.Ui exposing (..)
import Window
import Task
import AnimationFrame
import Keyboard exposing (KeyCode)
import WebSocket


type Msg
  =  Tick Time
  | KeyChange Bool KeyCode
  | StartGame
  | TimeSecond Time
  | SocketMessage String
  | NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
  let
      keys = [ Keyboard.downs (KeyChange True)
             , Keyboard.ups (KeyChange False)
             ]
      animation = [ AnimationFrame.diffs Tick ]
      seconds = Time.every Time.second TimeSecond
      socket = WebSocket.listen model.urlListen SocketMessage
  in
     case model.ui.screen of
       StartScreen ->
         [ seconds ] |> Sub.batch
       PlayScreen ->
         [] ++ [ seconds ] ++ keys ++ animation ++ [socket] |> Sub.batch
       WinScreen ->
         [] |> Sub.batch



