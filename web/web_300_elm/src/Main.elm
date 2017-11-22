module Main exposing (..)

import Html exposing (Html)

import Model exposing (Model,initialModel)
import Update exposing (update)
import View exposing (view)
import Subscription exposing (subscriptions)

--------------------------------------------------------------------------- MAIN

main : Program Never Model Subscription.Msg
main =
  Html.program
  { init = (initialModel, Cmd.none)
  , update = update
  , view = view
  , subscriptions = subscriptions }
