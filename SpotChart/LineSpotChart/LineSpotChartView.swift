import UIKit
import Charts

public final class SpotChartFrameworkBundle {
    public static let main: Bundle = Bundle(for: SpotChartFrameworkBundle.self)
}

public protocol SpotChartDelegate: AnyObject {
    func selectMetersPressed()
}

public class LineSpotChartView: UIView, IAxisValueFormatter {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentainerView: UIView!
    @IBOutlet public weak var lineChartView: LineChartView!
    @IBOutlet weak var lineChartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAxisleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAxisLabel: UILabel!
    @IBOutlet weak var rightAxisLabel: UILabel!
    @IBOutlet weak var rightAxisTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tooltipView: UIView!
    @IBOutlet weak var tooltipStackView: UIStackView!
    @IBOutlet weak var tooltipRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tooltipWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var resetZoomButton: UIButton!
    @IBOutlet weak var rightResetZoomConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectMetersButton: UIButton!
    @IBOutlet weak var leadingLegendConstraint: NSLayoutConstraint!
    
    public var data: [LineSpotChartModel] = []
    
    var startDate: Date?
    var endDate: Date?
    
    public weak var delegate: SpotChartDelegate?
    
    public func reload() {
        reloadChart()
    }
    
    public func reloadLegend() {
        updateLegend()
    }
    
    public func setRangeDate(start: Date, end: Date) {
        self.startDate = start
        self.endDate = end
        xValues = createXAxis(startDate: start, endDate: end)
        setXAxisLabelCount()
    }
    
    public var isSelectMetersEnable: Bool = true {
        didSet {
            selectMetersButton.isHidden = !isSelectMetersEnable
            leadingLegendConstraint.constant = isSelectMetersEnable ? 110 : 0
        }
    }
    
    public var selectMeterIcon = UIImage.init(systemName: "chevron.down") {
        didSet {
            selectMetersButton.setImage(selectMeterIcon, for: .normal)
        }
    }
    
    public var selectMetersFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            selectMetersButton.titleLabel?.font = selectMetersFont
        }
    }
    
    public var containerBackgroundColor: UIColor = .systemGroupedBackground {
        didSet {
            self.contentView.backgroundColor = containerBackgroundColor
            self.contentainerView.backgroundColor = containerBackgroundColor
            tableView.backgroundColor = containerBackgroundColor
        }
    }
    
    public var lineChartViewHeight: CGFloat = 300.0 {
        didSet {
            self.lineChartViewHeightConstraint.constant = lineChartViewHeight
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
    
    public var zoomOutImage = UIImage(named: "magnifyingglass.circle") {
        didSet {
            resetZoomButton.setImage(zoomOutImage, for: .normal)
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
    
    public var legendTitleFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            tableView.layoutSubviews()
        }
    }
    
    public var legendTitleColor: UIColor = .label {
        didSet {
            tableView.layoutSubviews()
        }
    }
    
    public var xValues : [String] = [] {
        didSet {
            lineChartView.xAxis.valueFormatter = xValues.isEmpty ? nil : self
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        commonInit()
        setAxisTitle()
        setupAxisFormatter()
        setupCollectionView()
        setupRemovedTooltipGesture()
        setupUI()
        setupLineChartDelegate()
    }
    
    func commonInit() {
        SpotChartFrameworkBundle.main.loadNibNamed(LineSpotChartView.nameOfClass, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setupLineChartDelegate(){
        lineChartView.delegate = self
    }
    
    func setupCollectionView(){
        LegendTableViewCell.register(for: tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupUI(){
        tooltipView.layer.cornerRadius = 8
        tooltipView.backgroundColor = tooltipBackgroundColor.withAlphaComponent(0.6)
        tooltipStackView.backgroundColor = .clear
        rightAxisLabel.font = rightAxisTitleFont
        leftAxisLabel.font = leftAxisTitleFont
        resetZoomButton.layer.cornerRadius = resetZoomButton.frame.height / 2
        resetZoomButton.layer.shadowColor = UIColor.lightGray.cgColor
        resetZoomButton.layer.shadowRadius = 5
        resetZoomButton.layer.shadowOpacity = 0.7
        resetZoomButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        setColorOfSelectMeter()
    }
    
    public func setColorOfSelectMeter() {
        selectMetersButton.layer.cornerRadius = selectMetersButton.frame.height / 2
        selectMetersButton.titleLabel?.font = selectMetersFont
        selectMetersButton.backgroundColor = .tertiarySystemGroupedBackground
        selectMetersButton.setTitleColor(.label, for: .normal)
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
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelFont = leftAxisValueFont
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: sideAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        
        let rightAxis = lineChartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = rightAxisValueFont
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: sideAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        
        let bottomAxis = lineChartView.xAxis
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
                guard let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: start) else { break }
                if index % 24 == 0 {
                    dates.append(monthFormatter.string(from: start))
                } else {
                    dates.append(hourFormatter.string(from: start))
                }
                start = newDate
            }
            index += 1
        }
        return dates
    }
    
    @IBAction func resetZoomButtonPressed(_ sender: Any) {
        lineChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        reloadChart()
        resetZoomButton.isHidden = true
    }
    
    @IBAction func selectMetersPressed(_ sender: Any) {
        delegate?.selectMetersPressed()
    }
}

extension LineSpotChartView {
    func reloadChart(isCompleteRefresh: Bool = true){
        lineChartView.highlightValue(nil)
        tooltipStackView.removeAllArrangedSubviews()
        tooltipView.isHidden = true
        lineChartView.data = nil
        let dataSets = data.filter{ return $0.legend.isEnable && $0.data.count != 0 }.map{$0.data}
        let isLeftAxisEnabled = dataSets.contains(where: { $0.axisDependency == .left })
        lineChartView.leftAxis.enabled = isLeftAxisEnabled
        leftAxisLabel.isHidden = !isLeftAxisEnabled
        let isRightAxisEnabled = dataSets.contains(where: { $0.axisDependency == .right })
        lineChartView.rightAxis.enabled = isRightAxisEnabled
        rightAxisLabel.isHidden = !isRightAxisEnabled
        if !isLeftAxisEnabled && isRightAxisEnabled {
            lineChartView.rightAxis.gridColor = UIColor.lightGray
            lineChartView.rightAxis.gridLineDashLengths = [4,4]
            lineChartView.extraLeftOffset = 15
            lineChartView.extraRightOffset = 0
        } else if isLeftAxisEnabled && isRightAxisEnabled {
            lineChartView.rightAxis.gridColor = UIColor.clear
            lineChartView.extraLeftOffset = 0
            lineChartView.extraRightOffset =  0
        } else {
            lineChartView.rightAxis.gridColor = UIColor.clear
            lineChartView.extraLeftOffset = 0
            lineChartView.extraRightOffset = 15
        }
        if dataSets.isEmpty {
            updateLegend(isCompleteRefresh: isCompleteRefresh)
            return
        }
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        lineChartView.data = data
        updateLegend(isCompleteRefresh: isCompleteRefresh)
    }
    
    func updateLegend(isCompleteRefresh: Bool = true) {
        if isCompleteRefresh {
            tableView.reloadData()
        }
        tableView.layoutIfNeeded()

        let peakLegend = data.filter {
            $0.legend.isPeak == true && $0.legend.isWindow == false
        }
        heightTableViewConstraint.constant = peakLegend.isEmpty ? 45 : 90
    }
}

extension LineSpotChartView: ChartViewDelegate{
    //MARK: - chart selected
    public func chartValueSelected(_ chartView: ChartViewBase,
                                   entry: ChartDataEntry,
                                   highlight: Highlight) {
        if highlight.xPx > self.frame.midX {
            setTooltipPostion(position: .right)
        }else{
            setTooltipPostion(position: .left)
        }
        let itemSelected = chartView.data?.dataSets[highlight.dataSetIndex]
        let selectedColor = itemSelected?.colors.first ?? UIColor.lightGray
        let marker = CircleMarker(color: selectedColor)
        lineChartView.marker = marker
//        let marker: BalloonMarker = BalloonMarker(color: UIColor(red: 93/255, green: 186/255, blue: 215/255, alpha: 1),
//                                                  font: UIFont(name: "Helvetica", size: 12)!,
//                                                  textColor: UIColor.white,
//                                                  insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
//        marker.minimumSize = CGSize(width: 75.0, height: 35.0)//CGSize(75.0, 35.0)
//        lineChartView.marker = marker
        setTooltip(index: Int(entry.x))
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        resetSelectedChart()
    }
    
    func resetSelectedChart(){
        self.tooltipStackView.removeAllArrangedSubviews()
        self.tooltipView.isHidden = true
        self.lineChartView.highlightValue(nil)
    }
}

extension LineSpotChartView {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "the value " + String(value)
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let countDates = calcuteRengeDates()
        var index = 0
        if countDates == 1 {
            index = Int(value.rounded()/Double(5))
        }else{
            index = Int(value.rounded()/Double(60))
        }
        guard xValues.indices.contains(index) else { return "" }
        return xValues[index]
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        setXAxisLabelCount(scaleX: scaleX, scaleY: scaleY)
    }
    
    func setXAxisLabelCount(scaleX: CGFloat = 1.0, scaleY: CGFloat = 1.0){
        let range = calcuteRengeDates()
        let zoomOutCondition = lineChartView.isFullyZoomedOut
        resetZoomButton.isHidden = zoomOutCondition
        let rightConstraint = lineChartView.rightAxis.enabled ? 35.0 : 0
        rightResetZoomConstraint.constant = lineChartView.extraRightOffset + rightConstraint
        let scaleOutCondition = scaleX == 1.0000 && scaleY == 1.0000
        if range <= 1 {
            lineChartView.xAxis.setLabelCount(4, force: true)
            isEnableZoomDelegation(true)
            return
        }
        
        if scaleOutCondition {
            setZoomOutCountXAxis()
        }else{
            lineChartView.xAxis.setLabelCount(2, force: true)
        }
    }
    
    func setZoomOutCountXAxis(){
        isEnableZoomDelegation(true)
        lineChartView.doubleTapToZoomEnabled = false
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
        lineChartView.xAxis.setLabelCount(count, force: true)
    }
    
    func isEnableZoomDelegation(_ isEnable : Bool){
        lineChartView.pinchZoomEnabled = isEnable
        lineChartView.scaleXEnabled = isEnable
        lineChartView.scaleYEnabled = isEnable
        lineChartView.resetZoom()
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
extension LineSpotChartView {
    func setupRemovedTooltipGesture(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTooltip(sender:)))
        doubleTap.numberOfTouchesRequired = 2
        lineChartView.addGestureRecognizer(doubleTap)
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
        if lineModel.data.isEmpty { return }
        if Int(lineModel.data.xMax) < index,
           Int(lineModel.data.xMin) > index { return }
        if !lineModel.legend.isEnable { return }
        if lineModel.legend.isWindow { return }
        let titleLbl = UILabel()
        titleLbl.font = tooltipTitleFont
        titleLbl.textColor = tooltipTextColor
        titleLbl.textAlignment = .left
        titleLbl.text = lineModel.legend.key + ": "
        
        let valueLbl = UILabel()
        valueLbl.font = tooltipValueFont
        valueLbl.textColor = tooltipTextColor
        valueLbl.textAlignment = .right
        guard let data = lineModel.data.entries.filter { Int($0.x) == index }.first else { return }
        let value = data.y
        if lineModel.isRoundedValue || value > 99 {
            let valueRounded = Int(value.rounded(.toNearestOrAwayFromZero))
            valueLbl.text = String(valueRounded.thousandSeprate()!)
        }else{
            valueLbl.text = String(format: "%.2f",data.y)
        }
        let unitLabel = UILabel()
        unitLabel.font = tooltipUnitFont
        unitLabel.textColor = tooltipTextColor
        unitLabel.textAlignment = .left
        unitLabel.text = " " + lineModel.unit
        let unitWidth = unitLabel.intrinsicContentSize.width
        unitLabel.widthAnchor.constraint(equalToConstant: unitWidth).isActive = true
        let vStack = UIStackView(arrangedSubviews: [titleLbl,valueLbl,unitLabel])
        vStack.distribution = .fill
        stackView.append(vStack)
    }
    
    func presentTooltip(stackView: [UIView]) {
        tooltipStackView.removeAllArrangedSubviews()
        if stackView.count == 0 {
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

import CoreGraphics

open class BalloonMarker: MarkerImage {
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init()

        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }

    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()

        if let color = color
        {
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }

        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom

        UIGraphicsPushContext(context)

        label.draw(in: rect, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }

    open func setLabel(_ newLabel: String)
    {
        label = newLabel

        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedString.Key.font] = self.font
        _drawAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedString.Key.foregroundColor] = self.textColor

        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
