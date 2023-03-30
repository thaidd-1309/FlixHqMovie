//
//  FilterScreenViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 20/03/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Then

final class FilterScreenViewController: UIViewController {
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var allCategories = [FilterSectionModel]()
    private let shareTrigger = CommonTrigger.shared
    var viewModel: FilterViewModel!
    
    var resetTrigger = BehaviorSubject<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configFilterDataSectionModel()
        configTableView()
        configView()
        bindViewModel()
    }
    
    private func configFilterDataSectionModel() {
        allCategories = [
            FilterSectionModel(name: CategoryType.category.name, categories: CategoryType.category.categories),
            FilterSectionModel(name: CategoryType.region.name, categories: CategoryType.region.categories),
            FilterSectionModel(name: CategoryType.genre.name, categories: CategoryType.genre.categories),
            FilterSectionModel(name: CategoryType.periods.name, categories: CategoryType.periods.categories),
            FilterSectionModel(name: CategoryType.sortOption.name, categories: CategoryType.sortOption.categories)
        ]
    }
    
    private func configView() {
        containerView.layer.cornerRadius = LayoutOptions.containerView.cornerRadious
        resetButton.layer.cornerRadius = LayoutOptions.buttonInFilterScreen.cornerRadious
        applyButton.layer.cornerRadius = LayoutOptions.buttonInFilterScreen.cornerRadious
    }
    
    private func configTableView() {
        tableView.then {
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
            $0.register(nibName: CategoryTableViewCell.self)
        }
        
        bindDataToTableView()
    }
    
   private func setupCell(cell: CategoryTableViewCell, item: FilterSectionModel, type: CategoryType) {
        cell.resetTrigger = resetTrigger
        var indexs = [Int]()
        var categories = [String]()

        shareTrigger.allFilterTrigger.subscribe(onNext: { cellsSelected in
            switch type {
            case .category:
                indexs = cellsSelected[type.index]?.indexs ?? []
                categories = cellsSelected[type.index]?.categories ?? []
            case .region:
                indexs = cellsSelected[type.index]?.indexs ?? []
                categories = cellsSelected[type.index]?.categories ?? []
            case .genre:
                indexs = cellsSelected[type.index]?.indexs ?? []
                categories = cellsSelected[type.index]?.categories ?? []
            case .periods:
                indexs = cellsSelected[type.index]?.indexs ?? []
                categories = cellsSelected[type.index]?.categories ?? []
            case .sortOption:
                indexs = cellsSelected[type.index]?.indexs ?? []
                categories = cellsSelected[type.index]?.categories ?? []
            }
        })
        .disposed(by: disposeBag)
        cell.categoryType = type
        cell.bind(categories: item.categories, title: item.name, indexs: indexs, previousCategories: categories)
    }
    
    private func bindDataToTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FilterSectionModel>>(
            configureCell: {[unowned self] _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.defaultReuseIdentifier,
                                                               for: indexPath) as? CategoryTableViewCell
                else {
                    return UITableViewCell()
                }
                switch indexPath.row {
                case 0:
                    setupCell(cell: cell, item: item, type: .category)
                case 1:
                    setupCell(cell: cell, item: item, type: .region)
                case 2:
                    setupCell(cell: cell, item: item, type: .genre)
                case 3:
                    setupCell(cell: cell, item: item, type: .periods)
                case 4:
                    setupCell(cell: cell, item: item, type: .sortOption)
                default:
                    break
                }
                return cell
            })
        
        Driver.of(allCategories)
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension FilterScreenViewController {
    private func bindViewModel() {
        configApplyButton()
        configResetButton()
    }
    
    private func configApplyButton() {
        applyButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    private func configResetButton() {
        resetButton.rx.tap.subscribe(onNext: { [unowned self] in
            resetTrigger.onNext(true)
        })
        .disposed(by: disposeBag)
    }
}

extension FilterScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
}
