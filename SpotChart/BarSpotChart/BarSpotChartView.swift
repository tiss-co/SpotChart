//
//  BarSpotChartView.swift
//  SpotChart
//
//  Created by Amir on 5/12/21.
//

import UIKit
import Charts

public class BarSpotChartView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentainerView: UIView!
    @IBOutlet public weak var barChartView: BarChartView!
    @IBOutlet weak var barChartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAxisleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAxisLabel: UILabel!
    @IBOutlet weak var rightAxisLabel: UILabel!
    @IBOutlet weak var rightAxisTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var legendCollectionView: UICollectionView!
    @IBOutlet weak var legendCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tooltipView: UIView!
    @IBOutlet weak var tooltipStackView: UIStackView!
    @IBOutlet weak var tooltipRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tooltipWidthConstraint: NSLayoutConstraint!
    
    
    public var data: [LineSpotChartModel] = [] {
        didSet {
            reloadChart()
        }
    }
    
    var startDate: Date?
    var endDate: Date?
    
    public func setRangeDate(start: Date, end: Date) {
        self.startDate = start
        self.endDate = end
        xValues = createXAxis(startDate: start, endDate: end)
        setXAxisLabelCount()
    }
    
    public var barChartViewHeight: CGFloat = 300.0 {
        didSet {
            self.barChartViewHeightConstraint.constant = barChartViewHeight
            self.setNeedsLayout()
        }
    }
    
    public var leftAxisTitleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.leftAxisLabel.font = leftAxisTitleFont
        }
    }
    
    public var rightAxisTitleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            self.rightAxisLabel.font = rightAxisTitleFont
        }
    }
    
    public var leftAxisValueFont: UIFont = UIFont.systemFont(ofSize: 10) {
        didSet {
            setupAxisFormatter()
        }
    }
    
    public var rightAxisValueFont: UIFont = UIFont.systemFont(ofSize: 10){
        didSet {
            setupAxisFormatter()
        }
    }
    
    public var bottomAxisValueFont: UIFont = UIFont.systemFont(ofSize: 10){
        didSet {
            setupAxisFormatter()
        }
    }
    
    //MARK:- Tooltip section properties
    private var tooltipStackViewTag: Int = 666333
    public var tooltipBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6) {
        didSet {
            self.tooltipView.backgroundColor = tooltipBackgroundColor
        }
    }
    
    public var tooltipWidth: CGFloat = 140 {
        didSet {
            tooltipWidthConstraint.constant = tooltipWidth
        }
    }
    
    public var tooltipPadding: CGFloat = 60.0
    public var tooltipTextColor: UIColor = .black
    public var tooltipItemsSpacing: CGFloat = 8
    public var tootTipItemsUnit: String = ""
    public var tooltipTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    public var tooltipValueFont: UIFont = UIFont.systemFont(ofSize: 11)
    public var tooltipUnitFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    public var fullDateFormat: String = "d.MMM HH:mm a"
    public var dayAxisLabelFormat: String = "d.MMM"
    public var hourAxisLabelFormat: String = "HH:mm"
    
    public var legendTitleFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            self.legendCollectionView.layoutSubviews()
        }
    }
    
    public var legendTitleColor: UIColor = UIColor.black {
        didSet {
            self.legendCollectionView.layoutSubviews()
        }
    }
    
    public var xValues : [String] = [] {
        didSet {
            //            barChartView.xAxis.valueForma/tter = xValues.isEmpty ? nil : self
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setAxisTitle()
        setupAxisFormatter()
        setupCollectionView()
        setupRemovedTooltipGesture()
        setupUI()
        setupLineChartDelegate()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setAxisTitle()
        setupAxisFormatter()
        setupCollectionView()
        setupRemovedTooltipGesture()
        setupUI()
        setupLineChartDelegate()
    }
    
    func commonInit() {
        SpotChartFrameworkBundle.main.loadNibNamed(BarSpotChartView.nameOfClass, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setupLineChartDelegate(){
        barChartView.delegate = self
    }
    
    func setupCollectionView(){
        LegendCollectionViewCell.register(for: legendCollectionView)
        legendCollectionView.dataSource = self
        legendCollectionView.delegate = self
    }
    
    func setupUI(){
        self.tooltipView.layer.cornerRadius = 8
        self.tooltipView.backgroundColor = tooltipBackgroundColor.withAlphaComponent(0.6)
        self.tooltipStackView.backgroundColor = .clear
        self.rightAxisLabel.font = rightAxisTitleFont
        self.leftAxisLabel.font = leftAxisTitleFont
        
    }
    
    public func setAxisTitle(leftTitle: String? = nil, rightTitle : String? = nil){
        self.leftAxisLabel.text = leftTitle
        self.rightAxisLabel.text = rightTitle
        self.layoutIfNeeded()
        self.leftAxisLabel.transform = CGAffineTransform.identity
        self.rightAxisLabel.transform = CGAffineTransform.identity
        
        leftAxisleadingConstraint.constant = -(self.leftAxisLabel.bounds.width/2) + 10
        rightAxisTrailingConstraint.constant = -(self.rightAxisLabel.bounds.width/2) + 10
        leftAxisLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        rightAxisLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    func setupAxisFormatter(){
        let sideAxisFormatter = NumberFormatter()
        sideAxisFormatter.numberStyle = .decimal
        sideAxisFormatter.groupingSeparator = ","
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = leftAxisValueFont
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: sideAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = rightAxisValueFont
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: sideAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        
        let bottomAxis = barChartView.xAxis
        bottomAxis.enabled = true
        bottomAxis.labelFont = bottomAxisValueFont
        bottomAxis.valueFormatter = bottomAxis.valueFormatter
    }
    
    func findDateAndTime(start : Date, index : Int, step: Int)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dayAxisLabelFormat
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = fullDateFormat
        
        let sDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: start)
        
        let day = index/1440
        let minute = (index - (day * 1440))
        
        guard let newDate = Calendar.current.date(byAdding: .day, value: day, to: sDate!) else { return ""}
        if minute == 0 {
            let dateString = dateFormatter.string(from: newDate)
            return dateString
        }
        guard let newDateWithMinute = Calendar.current.date(byAdding: .minute, value: minute, to: newDate) else { return ""}
        
        let dateString = newFormatter.string(from: newDateWithMinute)
        return dateString
    }
    
    //MARK: - Found x value data
    func createXAxis(startDate: Date, endDate: Date) -> [String] {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = dayAxisLabelFormat
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = hourAxisLabelFormat
        var start = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate) ?? startDate
        let end = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: endDate) ?? endDate
        let components = Calendar.current.dateComponents([.day], from: start, to: end)
        var dates: [String] = []
        var index = 0
        while start <= end {
            if components.day == 1 {
                guard let newDate = Calendar.current.date(byAdding: .minute, value: 5, to: start) else { break }
                if index % 288 == 0{
                    dates.append(monthFormatter.string(from: start))
                }else{
                    dates.append(hourFormatter.string(from: start))
                }
                start = newDate
            }else{
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: start) else { break }
                dates.append(monthFormatter.string(from: start))
                start = newDate
            }
            index += 1
        }
        return dates
    }
}

extension BarSpotChartView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = legendCollectionView.dequeueReusableCell(withReuseIdentifier: LegendCollectionViewCell.nameOfClass, for: indexPath) as! LegendCollectionViewCell
        let legend = data[indexPath.row].legend
        cell.setupUI(backgroundColor: .clear, textColor: legendTitleColor, textFont: legendTitleFont, legendShape: legend.legendShape)
        cell.getDate(legendModel: legend)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tooltipView.isHidden = true
        self.barChartView.highlightValue(nil)
        data[indexPath.row].legend.isEnable = !data[indexPath.row].legend.isEnable
        reloadChart()
    }
    
    func reloadChart(){
        let dataSets = data.filter{return $0.legend.isEnable}.map{$0.data}
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        DispatchQueue.main.async {[self] in
            barChartView.data = data
            legendCollectionView.reloadData()
            layoutIfNeeded()
            let height = legendCollectionView.collectionViewLayout.collectionViewContentSize.height
            legendCollectionViewHeightConstraint.constant = height
            
        }
    }
}


extension BarSpotChartView : ChartViewDelegate{
    //MARK: - chart selected
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if highlight.xPx > self.frame.midX {
            setTooltipPostion(position: .right)
        }else{
            setTooltipPostion(position: .left)
        }
        setTooltip(index: Int(entry.x))
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        resetSelectedChart()
    }
    
    func resetSelectedChart(){
        DispatchQueue.main.async {[self] in
            self.tooltipStackView.removeAllArrangedSubviews()
            self.tooltipView.isHidden = true
            self.barChartView.highlightValue(nil)
        }
    }
}

extension BarSpotChartView {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "the value " + String(value)
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let countDates = calcuteRengeDates()
        var index = 0
        if countDates == 1 {
            index = Int(value.rounded()/Double(5))
        }else{
            index = Int(value.rounded()/Double(1440))
        }
        guard xValues.indices.contains(index) else { return "" }
        return xValues[index]
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        setXAxisLabelCount(scaleX: scaleX, scaleY: scaleY)
    }
    
    func setXAxisLabelCount(scaleX: CGFloat = 1.0, scaleY: CGFloat = 1.0){
        let range = calcuteRengeDates()
        if range <= 1{
            barChartView.xAxis.setLabelCount(4, force: true)
            return
        }
        if scaleX == 1 && scaleY == 1{
            setZoomOutCountXAxis()
        }else{
            barChartView.xAxis.setLabelCount(2, force: true)
        }
    }
    
    func setZoomOutCountXAxis(){
        isEnableZoomDelegation(true)
        barChartView.doubleTapToZoomEnabled = false
        let countDates = calcuteRengeDates()
        var count = 0
        if countDates <= 1{
            count = 4
        }
        else if countDates <= 5{
            count = countDates + 1
        }
        else {
            count = (countDates+1) % 2 == 0 ? 5 : 4
            isEnableZoomDelegation(false)
        }
        barChartView.xAxis.setLabelCount(count, force: true)
    }
    
    func isEnableZoomDelegation(_ isEnable : Bool){
        barChartView.pinchZoomEnabled = isEnable
        barChartView.scaleXEnabled = isEnable
        barChartView.scaleYEnabled = isEnable
        barChartView.resetZoom()
    }
    
    func calcuteRengeDates() -> Int{
        let components = Calendar.current.dateComponents([.day],
                                                         from: startDate ?? Date(),
                                                         to: endDate ?? Date())
        let countDates = (components.day ?? 0)
        return countDates
    }
}


//MARK: Tooltip
extension BarSpotChartView {
    func setupRemovedTooltipGesture(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip(sender:)))
        doubleTap.numberOfTouchesRequired = 2
        barChartView.addGestureRecognizer(doubleTap)
        let tapOnTooltip = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip(sender:)))
        tapOnTooltip.numberOfTouchesRequired = 1
        tooltipView.addGestureRecognizer(tapOnTooltip)
    }
    
    @objc func dismissTooltip(sender: UITapGestureRecognizer){
        resetSelectedChart()
    }
    
    func setTooltip(index : Int){
        var stackView : [UIView] = []
        
        addTimeToTooltip(stackView: &stackView, index: index)
        
        
        for lineModel in data{
            addEnableDataToTooltip(stackView: &stackView,
                                   index: index,
                                   lineModel: lineModel)
        }
        
        DispatchQueue.main.async {
            self.presentTooltip(stackView: stackView)
        }
    }
    
    func addTimeToTooltip(stackView: inout [UIView], index: Int){
        if let startDate = startDate{
            let timeLbl = UILabel()
            timeLbl.font = tooltipTitleFont
            timeLbl.textColor = tooltipTextColor
            timeLbl.textAlignment = .left
            let step = data.first?.step ?? 1
            timeLbl.text = findDateAndTime(start: startDate,
                                           index: index,
                                           step: step)
            
            stackView.append(timeLbl)
        }
    }
    
    func addEnableDataToTooltip(stackView: inout [UIView],
                                index: Int,
                                lineModel: LineSpotChartModel){
        guard lineModel.data.entries.count > index/lineModel.step ,
              lineModel.legend.isEnable else { return }
        let titleLbl = UILabel()
        titleLbl.font = tooltipTitleFont
        titleLbl.textColor = tooltipTextColor
        titleLbl.textAlignment = .left
        titleLbl.text = lineModel.legend.key + ": "
        let valueLbl = UILabel()
        valueLbl.font = tooltipValueFont
        valueLbl.textColor = tooltipTextColor
        valueLbl.textAlignment = .right
        if lineModel.isRoundedValue {
            let value = Int(lineModel.data.entries[index/lineModel.step].y.rounded())
            valueLbl.text = String(value.thousandSeprate()!)
        }else{
            let value = lineModel.data.entries[index/lineModel.step].y
            valueLbl.text = String(format: "%.2f",value)
        }
        let unitLabel = UILabel()
        unitLabel.font = tooltipUnitFont
        unitLabel.textColor = tooltipTextColor
        unitLabel.textAlignment = .left
        unitLabel.text = " " + tootTipItemsUnit
        let unitWidth = unitLabel.intrinsicContentSize.width
        unitLabel.widthAnchor.constraint(equalToConstant: unitWidth).isActive = true
        let vStack = UIStackView(arrangedSubviews: [titleLbl,valueLbl,unitLabel])
        vStack.distribution = .fill
        stackView.append(vStack)
    }
    
    func presentTooltip(stackView: [UIView]) {
        tooltipStackView.removeAllArrangedSubviews()
        if stackView.count == 0{
            return
        }else{
            tooltipView.isHidden = false
        }
        let vStack = UIStackView(arrangedSubviews: stackView)
        vStack.tag = tooltipStackViewTag
        vStack.axis = .vertical
        vStack.spacing = tooltipItemsSpacing
        tooltipStackView.addArrangedSubview(vStack)
        tooltipStackView.distribution = .fillEqually
    }
    
    func setTooltipPostion(position: tooltipPositionEnum) {
        let screenWidth = self.frame.width
        let tooltipWidth = self.tooltipView.frame.width
        var padding: CGFloat = tooltipPadding
        let lineChartPadding: CGFloat = 15
        
        DispatchQueue.main.async {
            switch position {
            case .right:
                padding = screenWidth - tooltipWidth - padding - lineChartPadding
                self.tooltipRightConstraint.constant = padding
            case .left:
                self.tooltipRightConstraint.constant = padding - lineChartPadding
            }
        }
    }
    
    enum tooltipPositionEnum {
        case right
        case left
    }
    
}
