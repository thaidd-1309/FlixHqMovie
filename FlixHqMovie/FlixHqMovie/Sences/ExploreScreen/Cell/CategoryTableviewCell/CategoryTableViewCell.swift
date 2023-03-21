//
//  CategoryTableViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 20/03/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class CategoryTableViewCell: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryNameLabel: UILabel!

    private var disposeBag = DisposeBag()
    private var categories = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        categoryNameLabel.text = nil
    }

    private func configCollectionView() {
        collectionView.register(nibName: FilterCollectionViewCell.self)
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    func bind(categories: [String], title: String) {
        self.categories = categories
        setTitleCategory(name: title)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.defaultReuseIdentifier,
                                                                    for: indexPath) as? FilterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setTextInLabel(name: item)
                return cell
            }
        )
        Driver.of(categories).map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }

    private func setTitleCategory(name: String) {
        categoryNameLabel.text = name
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = categories[indexPath.row]
        label.numberOfLines = 0
        let maxSize = CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label.sizeThatFits(maxSize)
        let collectionViewWidth = collectionView.frame.width / 6
        let cellWidth = requiredSize.width > collectionViewWidth ? requiredSize.width : collectionViewWidth
        let cellHeight = LayoutCell.heightRatio.value * requiredSize.height
        return CGSize(width: cellWidth + LayoutCell.paddingWidth.value, height: cellHeight )
    }
}
