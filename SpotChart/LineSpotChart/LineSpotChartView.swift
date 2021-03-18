import UIKit
import Charts

public class LineSpotChartView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet public weak var lineChartView: LineChartView!
    @IBOutlet weak var leftAxisleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftAxisLabel: UILabel!
    @IBOutlet weak var rightAxisLabel: UILabel!
    @IBOutlet weak var rightAxisTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var legendCollectionView: UICollectionView!
    
    @IBOutlet weak var tooltipView: UIView!
    
    public final class SpotChartFrameworkBundle {
        public static let main: Bundle = Bundle(for: SpotChartFrameworkBundle.self)
    }
    
    
    var data: [LineSpotChartModel] = [] {
        didSet {
            
        }
    }
    
    //MARK:- Tooltip section properties
    private var tooltipStackViewTag: Int = 666333
    var tooltipTextColor: UIColor = .black
    var tooltipBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6)
    var tooltipItemsSpacing: CGFloat = 8
    var tootTipItemsUnit: String = "MW"
    var tooltipTitleFont: UIFont = UIFont.systemFont(ofSize: 12)
    var tooltipValueFont: UIFont = UIFont.systemFont(ofSize: 10)
    var tooltipUnitFont: UIFont = UIFont.systemFont(ofSize: 8)
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setAxisTitle()
        setupCollectionView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setAxisTitle()
        setupCollectionView()
    }
    
    func commonInit() {
        SpotChartFrameworkBundle.main.loadNibNamed(LineSpotChartView.nameOfClass, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setupCollectionView(){
        LegendCollectionViewCell.register(for: legendCollectionView)
        legendCollectionView.dataSource = self
        legendCollectionView.delegate = self
    }
    
    func setupUI(){
        
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
    
    func setTooltip(index : Int){
        var stackViews : [UIView] = []
        
        let timeLbl = UILabel()
        timeLbl.font = tooltipTitleFont
        timeLbl.textColor = tooltipTextColor
        timeLbl.textAlignment = .left
        
//        if let startDate = startDate ?? Date().convertToLocalTime(fromTimeZone: "EST") {
//            timeLbl.text = findDateAndTime(start: startDate, index: index/5)
//        }else{
//            timeLbl.text = ""
//        }
        
        stackViews.append(timeLbl)
        
        for i in data{
            if i.data.entries.count > index/i.step && i.legend.isEnable{
                let titleLbl = UILabel()
                titleLbl.font = tooltipTitleFont
                titleLbl.textColor = tooltipTextColor
                titleLbl.textAlignment = .left
                titleLbl.text = i.legend.key + ": "
                let valueLbl = UILabel()
                valueLbl.font = tooltipTitleFont
                valueLbl.textColor = tooltipTextColor
                valueLbl.textAlignment = .right
                
//                if i.0 == FACILITY_CHART_KEY {
//                    valueLbl.text = String(format: "%.2f",i.1.entries[index/i.3].y)
//                }else{
//                    valueLbl.text = String(Int(i.1.entries[index/i.3].y.rounded()).thousandSeprate()!)
//                }
                let unitLabel = UILabel()
                unitLabel.font = tooltipTitleFont
                unitLabel.textColor = tooltipTextColor
                unitLabel.textAlignment = .left
                unitLabel.text = tootTipItemsUnit
                unitLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
                let vStack = UIStackView(arrangedSubviews: [titleLbl,valueLbl,unitLabel])
                vStack.distribution = .fill
                stackViews.append(vStack)
            }else{
                continue
            }
        }
        DispatchQueue.main.async { [self] in
            removeTooltipSubviews()
            if stackViews.count == 0{
                return
            }else{
                tooltipView.isHidden = false
            }
            let vStack = UIStackView(arrangedSubviews: stackViews)
            vStack.tag = tooltipStackViewTag
            vStack.axis = .vertical
            vStack.spacing = tooltipItemsSpacing
            vStack.distribution = .fillEqually
            vStack.topAnchor.constraint(equalTo: tooltipView.topAnchor).isActive = true
            vStack.topAnchor.constraint(equalTo: tooltipView.topAnchor).isActive = true
            vStack.topAnchor.constraint(equalTo: tooltipView.topAnchor).isActive = true
            vStack.topAnchor.constraint(equalTo: tooltipView.topAnchor).isActive = true
            tooltipView.addSubview(vStack)
        }
    }
    
    func removeTooltipSubviews(){
        tooltipView.isHidden = true
        for i in tooltipView.subviews {
            if i == viewWithTag(tooltipStackViewTag){
                i.removeFromSuperview()
            }
        }
    }
}

extension LineSpotChartView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = legendCollectionView.dequeueReusableCell(withReuseIdentifier: LegendCollectionViewCell.nameOfClass, for: indexPath) as! LegendCollectionViewCell
        let legend = data[indexPath.row].legend
        cell.setupUI(backgroundColor: .clear, textColor: .black, textFont: .systemFont(ofSize: 14), legendShape: .circle)
        cell.getDate(legendModel: legend)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.toolTipBgView.isHidden = true
//        self.chartView.highlightValue(nil)
        data[indexPath.row].legend.isEnable = !data[indexPath.row].legend.isEnable
        legendCollectionView.reloadData()
    }
}


extension LineSpotChartView {
    //MARK: - chart selected
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        setTooltip(index: Int(entry.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        resetSelectedChart()
    }
    
    func resetSelectedChart(){
        DispatchQueue.main.async {[self] in
            removeTooltipSubviews()
            self.lineChartView.highlightValue(nil)
        }
    }
}

