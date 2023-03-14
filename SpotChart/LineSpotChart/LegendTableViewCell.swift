//
//  LegendTableViewCell.swift
//  SpotChart
//
//  Created by amir on 9/26/22.
//

import UIKit

protocol LegendDelegate: AnyObject {
    func legendSelected(section: Int, item: Int)
}

class LegendTableViewCell: UITableViewCell {
    @IBOutlet weak var legendCollectionView: UICollectionView!
    
    var data: [LineSpotChartModel]?
    var section: Int?
    var textColor: UIColor = .label
    var textFont: UIFont = UIFont.systemFont(ofSize: 12)
    weak var delegate: LegendDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(data: [LineSpotChartModel], section: Int) {
        self.data = data
        self.section = section
        legendCollectionView.reloadData()
        updateLayoutInset()
    }
    
    func setupUI(textColor: UIColor,
                 textFont: UIFont,
                 backgroundColor: UIColor) {
        self.textColor = textColor
        self.textFont = textFont
        self.contentView.backgroundColor = backgroundColor
        self.legendCollectionView.backgroundColor = backgroundColor
    }
    
    func updateLayoutInset() {
        legendCollectionView.layoutIfNeeded()
        DispatchQueue.main.async { [self] in
            let contentSize = legendCollectionView.contentSize.width
            var leftInset: CGFloat = 10
            var rightInset: CGFloat = 10
            if contentSize < legendCollectionView.frame.width {
                leftInset = (legendCollectionView.frame.width - contentSize) / 2
                rightInset = (legendCollectionView.frame.width - contentSize) / 2
            }
            legendCollectionView.contentInset = UIEdgeInsets(top: 0,
                                                             left: leftInset,
                                                             bottom: 0,
                                                             right: rightInset)
        }
    }
    
    func setupCollectionView() {
        legendCollectionView.dataSource = self
        legendCollectionView.delegate = self
        LegendCollectionViewCell.register(for: legendCollectionView)
    }
 
}

extension LegendTableViewCell: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = legendCollectionView.dequeueReusableCell(withReuseIdentifier: LegendCollectionViewCell.nameOfClass, for: indexPath) as? LegendCollectionViewCell
        if let item = data?[indexPath.item] {
            cell?.setupUI(backgroundColor: .clear,
                          textColor: textColor,
                          textFont: textFont,
                          legendShape: item.legend.legendShape)
            cell?.getDate(legendModel: item.legend)
        }
        return cell ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        guard let section else { return }
        delegate?.legendSelected(section: section, item: indexPath.item)
        data?[indexPath.item].legend.isEnable.toggle()
        collectionView.reloadItems(at: [indexPath])
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let legend = data?[indexPath.item].legend else {
            return CGSize(width: .zero, height: 45)
        }
        let text = legend.key ?? ""
        let size = text.size(withAttributes:[.font: textFont])
        var space = 45.0
        if legend.legendShape.rawValue == LengendStatusShapeEnum.circle.rawValue { space = 40.0 }
        let widthSize = size.width + space
        return CGSize(width: widthSize, height: 45)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension LegendTableViewCell {
    class func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: LegendTableViewCell.nameOfClass,
                                 bundle: SpotChartFrameworkBundle.main),
                           forCellReuseIdentifier: LegendTableViewCell.nameOfClass)
    }
}
