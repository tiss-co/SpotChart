import Foundation
import Charts

struct LineSpotChartModel {
    var legend: LegendModel
    var properties: LineSpotChartProperties
    var data: LineChartDataSet
    var step: Int = 1
}
