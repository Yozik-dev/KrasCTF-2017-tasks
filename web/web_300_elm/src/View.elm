module View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Svg exposing (Svg,Attribute)
import Svg.Attributes as Attributes exposing (x,y,width,height,fill,fontFamily,textAnchor)
import Svg.Events exposing (onClick)
import Time exposing (Time)
import String

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Scene exposing (..)
import Subscription exposing (..)

import VirtualDom
import Json.Encode as Json


view : Model -> Html Msg
view {ui,scene,secondsPassed} =
  case ui.screen of
    StartScreen ->
      renderStartScreen ui.windowSize secondsPassed

    PlayScreen ->
      renderPlayScreen ui.windowSize scene ui

    WinScreen ->
      div [class "win-message"] [Html.text ui.winMessage]


renderStartScreen : (Int,Int) -> Int -> Html Msg
renderStartScreen (w,h) secondsPassed =
  let
      clickHandler = onClick StartGame
      screenAttrs = [ clickHandler ] ++ (svgAttributes (w,h))
      title = largeText w h (h//5) "Stone hunter"
      clickToStart = smallText w h (h*6//8) "Click to start"
      paragraph y lines = renderTextParagraph (w//2) y (normalFontSize w h) "middle" lines []
      keys = paragraph (h*3//8) [ "Player keys: W A S D" ]
      goal = paragraph (h*4//8) [ "Get points for pushing", "the other off the edge" ]
      win  = paragraph (h*5//8) [ "Score 1000 points to win!" ]
      hardwareWarning1 = paragraph (h*9//20) [ "You need a keyboard" ]
      hardwareWarning2 = paragraph (h*10//20) [ "to play this game :(" ]
      authorLink = renderTextLine (w//2) (h*7//8) (normalFontSize w h) "middle" "Created by Statos" []
      children =
        if w < 600 then
          [ title, hardwareWarning1, hardwareWarning2 ]
        else
          [ title, authorLink ]
          ++ (if secondsPassed >= 1 then [ keys, goal, win ] else [] )
          ++ (if secondsPassed >= 3 && secondsPassed%2 == 1 then [ clickToStart ] else [] )
  in
      Svg.svg
        screenAttrs
        children


renderPlayScreen : (Int, Int) -> Scene -> Ui -> Html Msg
renderPlayScreen windowSize scene ui =
     Html.div [class "game-box"] [
        Svg.svg (svgAttributes windowSize) (
            [
              renderWall windowSize
              , renderPlayer scene.player
              , renderStar scene.star
            ]
            ++ renderEnemies scene.enemies
        ),
        Html.div [class "score-text"] [Html.text (toString scene.player.score)]
     ]


svgAttributes : (Int, Int) -> List (Attribute Msg)
svgAttributes (w, h) =
  [ width (toString w)
  , height (toString h)
  , Attributes.viewBox <| "0 0 " ++ (toString w) ++ " " ++ (toString h)
  , VirtualDom.property "xmlns:xlink" (Json.string "http://www.w3.org/1999/xlink")
  , Attributes.version "1.1"
  , Attributes.style "position: fixed; cursor: none;"
  ]


renderWall : (Int,Int) -> Svg Msg
renderWall (w,h) =
    Svg.rect
        [ x "0"
        , y "0"
        , width (toString w)
        , height (toString h)
        , fill "rgba(255,255,255,.5)"
        ]
        []


renderPlayer : Player -> Svg Msg
renderPlayer {position} =
    Svg.circle
        [  Attributes.cx (toString position.x)
        , Attributes.cy (toString position.y)
        , Attributes.r (toString playerRadius)
        , fill "rgba(255,0,0,.8)"
        ]
        []


renderStar : Star -> Svg Msg
renderStar {position} =
    Svg.circle
        [ Attributes.cx (toString position.x)
        , Attributes.cy (toString position.y)
        , Attributes.r (toString starRadius)
        , fill "rgba(255,255,0,.9)"
        ]
        []

renderEnemies : List Enemy -> List (Svg Msg)
renderEnemies enemies =
    List.map renderEnemy enemies

renderEnemy : Enemy -> Svg Msg
renderEnemy enemy =
    Svg.circle
        [ Attributes.cx (toString enemy.x)
        , Attributes.cy (toString enemy.y)
        , Attributes.r (toString playerRadius)
        , fill "rgba(0,0,255,.5)"
        ]
        []


normalFontSize : Int -> Int -> Int
normalFontSize w h =
  (min w h) // 20 |> min 24


largeText : Int -> Int -> Int -> String -> Svg Msg
largeText w h y str =
  renderTextLine (w//2) y ((normalFontSize w h)*2) "middle" str []


smallText : Int -> Int -> Int -> String -> Svg Msg
smallText w h y str =
  renderTextLine (w//2) y (normalFontSize w h) "middle" str []


renderTextParagraph : Int -> Int -> Int -> String -> List String -> List (Svg.Attribute Msg) -> Svg Msg
renderTextParagraph xPos yPos fontSize anchor lines extraAttrs =
  List.indexedMap (\index line -> renderTextLine xPos (yPos+index*fontSize*5//4) fontSize anchor line extraAttrs) lines
  |> Svg.g []


renderTextLine : Int -> Int -> Int -> String -> String -> List (Svg.Attribute Msg) -> Svg Msg
renderTextLine xPos yPos fontSize anchor content extraAttrs =
  let
      attributes = [ x <| toString xPos
                   , y <| toString yPos
                   , textAnchor anchor
                   , fontFamily "Courier New, Courier, Monaco, monospace"
                   , Attributes.fontSize (toString fontSize)
                   , fill "rgba(255,255,255,.8)"
                   ]
                   |> List.append extraAttrs
  in
      Svg.text_ attributes [ Svg.text content ]
