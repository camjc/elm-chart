import Chart
import Svg


main : Svg.Svg
main =
  Chart.pie 300 [{color = "#0ff", value = 3}, {color = "purple", value = 27}]
