//
//  BarSpotChartModel.swift
//  SpotChart
//
//  Created by Amir on 5/12/21.
//

import Foundation
import Charts

public struct BarSpotChartModel {
    public var legend: LegendModel
    public var data: BarChartDataSet
    public var startDate: Date?
    public var endDate: Date?
    public var step: Int
    public var isRoundedValue: Bool = true
    
    public init(legend: LegendModel,
                data: BarChartDataSet,
                step: Int = 1){
        self.legend = legend
        self.data = data
        self.step = step
    }
}
