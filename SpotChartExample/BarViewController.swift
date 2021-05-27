//
//  BarViewController.swift
//  SpotChartExample
//
//  Created by Amir on 5/27/21.
//

import UIKit
import SpotChart
import Charts

class BarViewController: UIViewController {

    @IBOutlet weak var barSpotChart: BarSpotChartView!
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barSpotChart.barChartView.maxVisibleCount = 40
        barSpotChart.barChartView.drawBarShadowEnabled = false
        barSpotChart.barChartView.drawValueAboveBarEnabled = false
        barSpotChart.barChartView.highlightFullBarEnabled = false
        
        let leftAxis = barSpotChart.barChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        
        barSpotChart.barChartView.rightAxis.enabled = false
        
        let xAxis = barSpotChart.barChartView.xAxis
        xAxis.labelPosition = .top
        
        let l = barSpotChart.barChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
    }
}
