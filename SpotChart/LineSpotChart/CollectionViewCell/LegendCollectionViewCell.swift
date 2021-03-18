import UIKit

class LegendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var legendStatusView: UIView!
    @IBOutlet weak var legendStatusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func getDate(legendModel: LegendModel) {
        legendStatusView.backgroundColor = legendModel.isEnable ? legendModel.color : legendModel.color.withAlphaComponent(0.3)
        titleLabel.text = legendModel.key
        titleLabel.textColor = legendModel.isEnable ? titleLabel.textColor : titleLabel.textColor.withAlphaComponent(0.3)
    }
    
    func setupUI(backgroundColor: UIColor = .clear,
                 textColor: UIColor = .black,
                 textFont: UIFont = .systemFont(ofSize: 16),
                 legendShape: LengendStatusShape
                 ){
        self.backgroundColor = backgroundColor
        titleLabel.textColor = textColor
        titleLabel.font = textFont
        setupLengendShape(legendShape: legendShape)
    }
    
    func setupLengendShape(legendShape: LengendStatusShape){
        switch legendShape {
        case .circle:
            legendStatusHeightConstraint.constant = legendStatusView.frame.width
        case .rectangle:
            legendStatusHeightConstraint.constant = legendStatusView.frame.width / 4
        case .square:
            legendStatusHeightConstraint.constant = legendStatusView.frame.width
        }
        legendStatusView.layer.cornerRadius = legendStatusView.frame.height / 2
    }
}

extension LegendCollectionViewCell {
    class func register(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: LegendCollectionViewCell.nameOfClass, bundle: Bundle.main),
                                forCellWithReuseIdentifier:  LegendCollectionViewCell.nameOfClass)
    }
}

public enum LengendStatusShape {
    case circle
    case rectangle
    case square
}
