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
    private var indexCellsSelected = [Int]()
    private var categoriesSeclected = [String]()
    private var filterTrigger = CommonTrigger.shared
    var categoryType: CategoryType?
    
    var resetTrigger = BehaviorSubject<Bool>(value: false)
    
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
        collectionView.allowsMultipleSelection = true
    }
    
    func bind(categories: [String], title: String, indexs: [Int], previousCategories: [String]) {
        self.categories = categories
        setTitleCategory(name: title)
        categoriesSeclected = previousCategories
        indexCellsSelected = indexs

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: {[unowned self] _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.defaultReuseIdentifier,
                                                                    for: indexPath) as? FilterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                for index in indexCellsSelected {
                    collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredVertically)
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
        configSelectedCell()
        updateAllFilterTrigger()
        resetTrigger.subscribe(onNext: {[unowned self] isReseted in
            if isReseted {
                indexCellsSelected = []
                categoriesSeclected = []
                updateAllFilterTrigger()
                collectionView.reloadData()
            }
        })
        .disposed(by: disposeBag)
    }

    private func setTitleCategory(name: String) {
        categoryNameLabel.text = name
    }
    
    private func configSelectedCell() {
        
        collectionView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            getInforCellsSelected(selected: true, indexDeSelected: indexPath)
        })
        .disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected.subscribe(onNext: { [unowned self] indexPath in
            indexCellsSelected = indexCellsSelected.filter { $0 != indexPath.row }
            getInforCellsSelected(selected: false, indexDeSelected: indexPath)
        })
        .disposed(by: disposeBag)
    }

    private func getInforCellsSelected(selected: Bool, indexDeSelected: IndexPath) {
        collectionView.indexPathsForSelectedItems?.forEach { indexPath in

            guard let cell = collectionView.cellForItem(at: indexPath ) as? FilterCollectionViewCell
            else { return }
            if selected {
                indexCellsSelected.append(indexPath.row)
                categoriesSeclected.append(cell.getTextInLabel())
                cell.configSelected(selected: true)
            }
        }
        if !selected {
            guard let cell = collectionView.cellForItem(at: indexDeSelected ) as? FilterCollectionViewCell
            else { return }
            cell.configSelected(selected: false)
            categoriesSeclected = categoriesSeclected.filter { $0 != cell.getTextInLabel() }
        }
        updateAllFilterTrigger()
    }

    private func updateFilterTrigger(categoryTrigger: CategoryTriggerType) {
        filterTrigger.allFilterTrigger.onNext(categoryTrigger.cellSelectedModel)
    }

    private func updateAllFilterTrigger() {
        let cellSelectedModel = CellSelectedModel(name: categoryNameLabel.text ?? "",
                                                  indexs: indexCellsSelected,
                                                  categories: categoriesSeclected)
        switch categoryType {
        case .category:
            updateFilterTrigger(categoryTrigger: .category(cellSelected: cellSelectedModel, type: .category))
        case .region:
            updateFilterTrigger(categoryTrigger: .region(cellSelected: cellSelectedModel, type: .region))
        case .genre:
            updateFilterTrigger(categoryTrigger: .genre(cellSelected: cellSelectedModel, type: .genre))
        case .periods:
            updateFilterTrigger(categoryTrigger: .periods(cellSelected: cellSelectedModel, type: .periods))
        case .sortOption:
            updateFilterTrigger(categoryTrigger: .sortOption(cellSelected: cellSelectedModel, type: .sortOption))
        default:
            break
        }
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
