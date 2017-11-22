module Update exposing (..)

import Char
import WebSocket
import Set exposing (Set)
import Time exposing (Time)
import Keyboard exposing (KeyCode)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Scene exposing (..)
import Model.Geometry exposing (..)
import Subscription exposing (..)
import Util exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update action ({ui,scene} as model) =
  case action of
    Tick delta ->
        let
          player_ = scene.player
            |> steerAndGravity delta ui
            |> movePlayer delta ui

          (isEat, star__) = scene.star |> getStar player_ ui
          player__ = addScore player_ isEat

          scene_ = { scene | player = player__, star = star__ }
          gameTime_ = model.gameTime + (delta * 1)
          model_ = { model | scene = scene_ , gameTime = gameTime_}

          cmd = if isEat then
                  WebSocket.send model.urlSend (eatStarMessage model)
                else
                  Cmd.none
        in
          (model_, [cmd, WebSocket.send model.urlSend (moveMessage model_)] |> Cmd.batch)

    KeyChange pressed keycode ->
        (handleKeyChange pressed keycode model, Cmd.none)

    StartGame ->
        (freshGame ui, Cmd.none)

    TimeSecond _ ->
        ({ model | secondsPassed = model.secondsPassed+1 }, Cmd.none)

    SocketMessage message ->
        let
          mes_action = stringDecoder "m" message
        in
          case mes_action of
            Ok "new_star" ->
                let
                   star_ = getStarPosition message |> updateStar scene.star
                   scene_ = { scene | star = star_ }
                in
                    ({model | scene = scene_ }, Cmd.none)
            Ok "win" ->
                let
                  flag_ = stringDecoder "flag" message |> Result.toMaybe |> Maybe.withDefault ""
                  ui_ = { ui | winMessage = flag_, screen = WinScreen}
                in
                  ({model | ui = ui_}, Cmd.none)
            Ok "players" ->
                let
                  enemies_ = getEnemies message
                  scene_ = { scene | enemies = enemies_ }
                in
                  ({model | scene = scene_ }, Cmd.none)
            _ ->
               (model, Cmd.none)

    NoOp ->
        (model, Cmd.none)



getStar : Player -> Ui -> Star -> (Bool, Star)
getStar p {windowSize} star =
    let
        d = distance (p.position.x, p.position.y) (star.position.x, star.position.y)
    in
        if d < (starRadius + playerRadius) then
            (True, updateStar star (Vector 1000 1000))
        else
            (False, star)

addScore : Player -> Bool -> Player
addScore p isEat =
    { p | score = if isEat then p.score + 1 else p.score }


updateStar : Star -> Vector -> Star
updateStar star vec =
    { star | position = vec }

movePlayer : Time -> Ui -> Player -> Player
movePlayer delta {windowSize} player =
    player
      |> walk delta
      |> blockWall windowSize


walk : Time -> Player -> Player
walk delta p =
  let
      x_ = p.position.x + p.velocity.x*delta
      y_ = p.position.y + p.velocity.y*delta
      pos_ = {x = x_, y = y_}
  in
      {p | position = pos_}

blockWall : (Int, Int) -> Player -> Player
blockWall (w,h) p =
  let
      w_ = (toFloat w)
      h_ = (toFloat h)
      x_ = if p.position.x > w_ then
             w_
           else if p.position.x < 0 then
             0
           else
             p.position.x
      y_ = if p.position.y > h_ then
             h_
           else if p.position.y < 0 then
             0
           else
             p.position.y
      vx_ = if p.position.x > w_ then
             0
            else if p.position.x < 0 then
             0
            else
             p.velocity.x
      vy_ = if p.position.y > h_ then
              0
            else if p.position.y < 0 then
              0
            else
              p.velocity.y

      pos_ = {x = x_, y = y_}
      vel_ = {x = vx_, y = vy_}
  in
      {p | position = pos_, velocity = vel_}



friction : Time -> Float -> Float
friction delta vx =
    vx / (1 + 0.0018*delta)


steerAndGravity : Time -> Ui -> Player -> Player
steerAndGravity delta {pressedKeys} ({velocity} as player) =
  let
      directionX = if keyPressed player.leftKey pressedKeys then
                     -1
                   else if keyPressed player.rightKey pressedKeys then
                     1
                   else
                     0
      directionY = if keyPressed player.upKey pressedKeys then
                     -1
                   else if keyPressed player.downKey pressedKeys then
                     1
                   else
                     0
      ax = directionX * 0.0001
      ay = directionY * 0.0001
      vx_ = velocity.x + ax*delta |> friction delta
      vy_ = velocity.y + ay*delta |> friction delta
      velocity_ = { velocity | x = vx_ , y = vy_ }
  in
      { player | velocity = velocity_ }


handleKeyChange : Bool -> KeyCode -> Model -> Model
handleKeyChange pressed keycode ({scene,ui} as model) =
  let
      fn = if pressed then Set.insert else Set.remove
      pressedKeys_ = fn keycode ui.pressedKeys
  in
      case ui.screen of
        PlayScreen ->
          let
              ui_ = { ui | pressedKeys = pressedKeys_ }
              justPressed keycode = freshKeyPress keycode ui.pressedKeys pressedKeys_
          in
              { model | ui = ui_ }
        _ ->
          model


freshKeyPress : KeyCode -> Set KeyCode -> Set KeyCode -> Bool
freshKeyPress keycode previouslyPressedKeys currentlyPressedKeys =
  let
      pressed = keyPressed keycode
  in
      pressed currentlyPressedKeys && not (pressed previouslyPressedKeys)
