import UIKit

class LegendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var legendStatusView: UIView!
    @IBOutlet weak var secondLegendStatusView: UIView!
    @IBOutlet weak var legendStatusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var legendStatusWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLegendStatusViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    let legendWidth: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        secondLegendStatusView.isHidden = true
    }
    
    func getDate(legendModel: LegendModel) {
        let legendColor = legendModel.isEnable ? legendModel.color : legendModel.color.withAlphaComponent(0.3)
        legendStatusView.backgroundColor = legendColor
        secondLegendStatusView.backgroundColor = legendColor
        titleLabel.text = legendModel.key
        titleLabel.textColor = legendModel.isEnable ? titleLabel.textColor : titleLabel.textColor.withAlphaComponent(0.3)
    }
    
    func setupUI(backgroundColor: UIColor = .clear,
                 textColor: UIColor = .black,
                 textFont: UIFont = .systemFont(ofSize: 16),
                 legendShape: LengendStatusShapeEnum
                 ){
        self.backgroundColor = backgroundColor
        titleLabel.textColor = textColor
        titleLabel.font = textFont
        setupLengendShape(legendShape: legendShape)
    }
    
    func setupLengendShape(legendShape: LengendStatusShapeEnum){
        switch legendShape {
        case .circle:
            legendStatusHeightConstraint.constant = legendWidth
            legendStatusWidthConstraint.constant = legendWidth
            legendStatusView.layer.cornerRadius = legendWidth / 2
            secondLegendStatusView.isHidden = true
        case .rectangle:
            legendStatusHeightConstraint.constant = legendWidth / 4
            legendStatusWidthConstraint.constant = legendWidth
            legendStatusView.layer.cornerRadius = legendWidth / 8
            secondLegendStatusView.isHidden = true
        case .square:
            legendStatusHeightConstraint.constant = legendWidth
            legendStatusWidthConstraint.constant = legendWidth
            legendStatusView.layer.cornerRadius = legendWidth / 4
            secondLegendStatusView.isHidden = true
        case .striped:
            legendStatusHeightConstraint.constant = legendWidth / 4
            legendStatusWidthConstraint.constant = legendWidth / 2
            legendStatusView.layer.cornerRadius = legendWidth / 8
            secondLegendStatusViewConstraint.constant = legendWidth / 4
            secondLegendStatusView.layer.cornerRadius = legendWidth / 8
            secondLegendStatusView.isHidden = false
        }
    }
}

extension LegendCollectionViewCell {
    class func register(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: LegendCollectionViewCell.nameOfClass,
                                      bundle: SpotChartFrameworkBundle.main),
                                forCellWithReuseIdentifier:  LegendCollectionViewCell.nameOfClass)
    }
}

public enum LengendStatusShapeEnum {
    case circle
    case rectangle
    case square
    case striped
}
