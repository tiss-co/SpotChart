//
//  ViewController.swift
//  SpotChartExample
//
//  Created by Amir on 3/15/21.
//

import UIKit
import SpotChart
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var lineSpotChart: LineSpotChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartView()
        setDataSet()
        setDataSet()
        setDataSet()
        setDataSet()
        setDataSet()
        setDataSet2()
        setDataSet3()
    }
    
    func setDataSet(){
        let legend = LegendModel(key: "legend1", color: .red, isEnable: true, legendShape: .rectangle)
        var entries : [BarChartDataEntry] = []
        var dataSet = LineChartDataSet()
        for i in 0..<289{
            let dataEntry = BarChartDataEntry(x:Double(i * 5),y: Double(i*i))
            entries.append(dataEntry)
        }
        dataSet = LineChartDataSet(entries: entries, label: legend.key)
        dataSet.drawCirclesEnabled = false
        dataSet.axisDependency = .left
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1.5
        dataSet.setColor(legend.color)
        dataSet.lineDashLengths = [4]
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        var data = LineSpotChartModel(legend: legend, data: dataSet)
        data.startDate = Date()
        let tommorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        data.endDate = tommorrowDate
        data.step = 5
        lineSpotChart.data.append(data)
    }
    
    func setDataSet2(){
        let legend = LegendModel(key: "legend2", color: .blue, isEnable: false, legendShape: .square)
        var entries : [BarChartDataEntry] = []
        var dataSet = LineChartDataSet()
        
        for i in 0..<1441{
            let dataEntry = BarChartDataEntry(x:Double(i),y: Double(i*2))
            entries.append(dataEntry)
        }
        
        dataSet = LineChartDataSet(entries: entries, label: legend.key)
        dataSet.drawCirclesEnabled = false
        dataSet.axisDependency = .right
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1.5
        dataSet.setColor(legend.color)
        dataSet.lineDashLengths = [4]
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        var data = LineSpotChartModel(legend: legend, data: dataSet)
//        data.startDate = Date()
        data.step = 1
        lineSpotChart.data.append(data)
    }
    
    func setDataSet3(){
        let legend = LegendModel(key: "legend 3", color: .brown, isEnable: true, legendShape: .circle)
        var entries : [BarChartDataEntry] = []
        var dataSet = LineChartDataSet()
        
        for i in 0..<25{
            let dataEntry = BarChartDataEntry(x:Double(i*60),y: Double(i*i*i))
            entries.append(dataEntry)
        }
        
        dataSet = LineChartDataSet(entries: entries, label: legend.key)
        dataSet.drawCirclesEnabled = false
        dataSet.axisDependency = .right
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1.5
        dataSet.setColor(legend.color)
        dataSet.lineDashLengths = [4]
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        var data = LineSpotChartModel(legend: legend, data: dataSet)
//        data.startDate = Date()
        data.step = 60
        lineSpotChart.data.append(data)
    }
    
    func setupChartView(){
        lineSpotChart.setAxisTitle(leftTitle: "left Axis", rightTitle: "right Axis")
        lineSpotChart.lineChartView.backgroundColor = UIColor.white
        lineSpotChart.lineChartView.rightAxis.enabled = true
        lineSpotChart.lineChartView.xAxis.labelPosition = .bottom
        lineSpotChart.lineChartView.pinchZoomEnabled = true
        lineSpotChart.lineChartView.setScaleEnabled(true)
        lineSpotChart.lineChartView.dragEnabled = true
        lineSpotChart.lineChartView.legend.enabled = false
        lineSpotChart.lineChartView.xAxis.gridColor = UIColor.clear
        lineSpotChart.lineChartView.xAxis.gridLineDashLengths = [4,4]
        lineSpotChart.lineChartView.rightAxis.gridColor = UIColor.clear
        lineSpotChart.lineChartView.rightAxis.gridLineDashLengths = [1]
        lineSpotChart.lineChartView.leftAxis.gridColor = UIColor.lightGray
        lineSpotChart.lineChartView.leftAxis.gridLineDashLengths = [4,4]
        lineSpotChart.lineChartView.xAxis.axisLineColor = .black
        lineSpotChart.lineChartView.leftAxis.axisLineWidth = 0
        lineSpotChart.lineChartView.leftAxis.axisLineColor = .black
        lineSpotChart.lineChartView.rightAxis.axisLineWidth = 0
        lineSpotChart.lineChartView.rightAxis.axisLineColor = .black
        lineSpotChart.lineChartView.rightAxis.labelCount = 5
        
        let marker = CircleMarker(color: .black)
        lineSpotChart.lineChartView.marker = marker
    }
}


