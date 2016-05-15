module Main exposing (main)

import Chart
import Svg


main : Svg.Svg a
main =
  Chart.pie 300 [ { color = "#0ff", value = 3 }, { color = "purple", value = 27 } ]
