import Foundation
import Charts

public struct LineSpotChartModel {
    public var legend: LegendModel
    public var data: LineChartDataSet
    public var unit: String
    public var startDate: Date?
    public var endDate: Date?
    public var step: Int
    public var isRoundedValue: Bool = true
    
    public init(legend: LegendModel,
                data: LineChartDataSet,
                step: Int = 1,
                unit: String = ""){
        self.legend = legend
        self.data = data
        self.step = step
        self.unit = unit
    }
}
