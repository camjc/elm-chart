module Chart (pie) where

{-| An SVG chart library.

# Pie
@docs pie

-}

import List
import Svg
import Svg.Attributes

type alias ArcOutput =
  { id: Int
  , x1: Float
  , y1: Float
  , x2: Float
  , y2: Float
  , largeArcFlag: Int
  , color: String}


type alias Datum =
  {color: String
  , value: Float}


type alias Dataset =
  List Datum


quarter : Float
quarter =
  pi / 2


half : Float
half =
  pi


round : Float
round =
  pi * 2


radius : Float
radius =
  0.5


donut : Bool
donut =
  False


diameter : Float
diameter =
  100


getPointX : Float -> Float
getPointX angle =
  radius * cos angle


getPointY : Float -> Float
getPointY angle =
  radius * sin angle


getTotalOfDataset : Dataset -> Float
getTotalOfDataset dataset =
  List.sum (List.map .value dataset)


getArc : {dataset: Dataset, datum: Datum, index: Int, total: Float} -> ArcOutput
getArc {dataset, datum, index, total} =
  let
    valuesSoFar = getTotalOfDataset (List.take index dataset)

    startAngle = round * valuesSoFar / total
    angle = round * datum.value / total
    endAngle = startAngle + angle
  in
    { id = index
    , x1 = getPointX startAngle
    , y1 = getPointY startAngle
    , x2 = getPointX endAngle
    , y2 = getPointY endAngle
    , largeArcFlag = if angle > half then 1 else 0
    , color = datum.color }


arcToPath : ArcOutput -> String
arcToPath {id, x1, y1, x2, y2, largeArcFlag, color} =
  "M0,0 L" ++
  toString x1 ++
  "," ++
  toString y1 ++
  " A0.5,0.5 0 " ++
  toString largeArcFlag ++
  ",1 " ++
  toString x2 ++
  "," ++
  toString y2 ++
  " z"


getArcs : Dataset -> List Svg.Svg
getArcs dataset =
  List.indexedMap (\index datum ->
    let
      dAttribute =
        { dataset = dataset
        , datum = datum
        , index = index
        , total = (getTotalOfDataset dataset)}
          |> getArc
          |> arcToPath
          |> Svg.Attributes.d
    in
      Svg.path([Svg.Attributes.fill datum.color, dAttribute]) []) dataset


{-| Draws a pie chart of given diameter of the dataset.

    Chart.pie 300 [{color = "#0ff", value = 3}, {color = "purple", value = 27}]
-}
pie : Int -> Dataset -> Svg.Svg
pie diameter dataset =
  let
    diameterString = toString diameter
  in
    Svg.svg

      [ Svg.Attributes.viewBox "-0.5 -0.5 1 1"
      , Svg.Attributes.width diameterString
      , Svg.Attributes.height diameterString ]

      (getArcs dataset)
