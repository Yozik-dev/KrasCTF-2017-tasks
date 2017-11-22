module Model.Geometry exposing (..)


type alias Vector =
  { x : Float
  , y : Float }


distance : (Float,Float) -> (Float,Float) -> Float
distance (x1,y1) (x2,y2) =
  (x2-x1)^2 + (y2-y1)^2 |> sqrt
