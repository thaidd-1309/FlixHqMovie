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
    var viewModel: FilterViewModel!
    
    var filterTrigger = BehaviorSubject<[FilterSectionModel]>(value: [])
    var resetTrigger = BehaviorSubject<Bool>(value: false)
    private var categoriesTrigger =  BehaviorSubject<[String]>(value: [])
    private var regionsTrigger = BehaviorSubject<[String]>(value: [])
    private var generesTrigger = BehaviorSubject<[String]>(value: [])
    private var periodsTrigger = BehaviorSubject<[String]>(value: [])
    private var sortOptionsTriger = BehaviorSubject<[String]>(value: [])
    private var indexCategoriesTrigger = BehaviorSubject<[Int]>(value: [])
    private var indexRegionsTrigger = BehaviorSubject<[Int]>(value: [])
    private var indexGenresTrigger = BehaviorSubject<[Int]>(value: [])
    private var indexPeriodsTrigger = BehaviorSubject<[Int]>(value: [])
    private var indexSortOptionsTrigger = BehaviorSubject<[Int]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configFilterDataSectionModel()
        configTableView()
        configView()
        bindViewModel()
    }
    
    private func configFilterDataSectionModel() {
        allCategories = [
            FilterCategoryModel.categories.value,
            FilterCategoryModel.regions.value,
            FilterCategoryModel.genres.value,
            FilterCategoryModel.periods.value,
            FilterCategoryModel.sortOptions.value
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

    private func setupCell(cell: CategoryTableViewCell, item: FilterSectionModel, stringTrigger: BehaviorSubject<[String]>, categoryFilter: CategoryTitle) {
        cell.categoriesTrigger = stringTrigger
        cell.resetTrigger = resetTrigger
        switch categoryFilter {
        case .category:
            cell.indexCategoriesTrigger = indexCategoriesTrigger
        case .region:
            cell.indexRegionsTrigger = indexRegionsTrigger
        case .genre:
            cell.indexGenresTrigger = indexGenresTrigger
        case .periods:
            cell.indexPeriodsTrigger = indexPeriodsTrigger
        case .sortOption:
            cell.indexSortOptionsTrigger = indexSortOptionsTrigger
        }
        let indexs =  UserDefaults.standard.value(forKey: categoryFilter.keyForIndex) as? [Int] ?? []
        let categories =  UserDefaults.standard.value(forKey: categoryFilter.keyForString) as? [String] ?? []
        cell.bind(categories: item.data, title: item.name, indexs: indexs, previousCategories: categories)
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
                    setupCell(cell: cell, item: item, stringTrigger: categoriesTrigger, categoryFilter: .category)
                case 1:
                    setupCell(cell: cell, item: item, stringTrigger: regionsTrigger, categoryFilter: .region)
                case 2:
                    setupCell(cell: cell, item: item, stringTrigger: generesTrigger, categoryFilter: .genre)
                case 3:
                    setupCell(cell: cell, item: item, stringTrigger: periodsTrigger, categoryFilter: .periods)
                case 4:
                    setupCell(cell: cell, item: item, stringTrigger: sortOptionsTriger, categoryFilter: .sortOption)
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
        let input = FilterViewModel.Input(
            categoriesTrigger: categoriesTrigger.asDriver(onErrorJustReturn: []),
            regionsTrigger: regionsTrigger.asDriver(onErrorJustReturn: []),
            generesTrigger: generesTrigger.asDriver(onErrorJustReturn: []),
            periodsTrigger: periodsTrigger.asDriver(onErrorJustReturn: []),
            sortOptionsTriger: sortOptionsTriger.asDriver(onErrorJustReturn: [])
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        configApplyButton(output: output)
        configResetButton(output: output)
    }

    private func configApplyButton(output: FilterViewModel.Output) {
        applyButton.rx.tap.subscribe(onNext: { [unowned self] in
            viewModel.saveToUserDefault(disposeBag: disposeBag,
                                        categoriesTrigger: indexCategoriesTrigger.asDriver(onErrorJustReturn: []),
                                        regionsTrigger: indexRegionsTrigger.asDriver(onErrorJustReturn: []),
                                        genresTrigger: indexGenresTrigger.asDriver(onErrorJustReturn: []),
                                        periodsTrigger: indexPeriodsTrigger.asDriver(onErrorJustReturn: []),
                                        sortOptionsTrigger: indexSortOptionsTrigger.asDriver(onErrorJustReturn: []), isIndex: true)
            viewModel.saveToUserDefault(
                disposeBag: disposeBag,
                categoriesTrigger: categoriesTrigger.asDriver(onErrorJustReturn: []),
                regionsTrigger: regionsTrigger.asDriver(onErrorJustReturn: []),
                genresTrigger: generesTrigger.asDriver(onErrorJustReturn: []),
                periodsTrigger: periodsTrigger.asDriver(onErrorJustReturn: []),
                sortOptionsTrigger: sortOptionsTriger.asDriver(onErrorJustReturn: []),
                isIndex: false)
            output.categoriesIsSelected.drive(onNext: { [unowned self] value in
                filterTrigger.onNext(value)
            })
            .disposed(by: disposeBag)
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func configResetButton(output: FilterViewModel.Output) {
        resetButton.rx.tap.subscribe(onNext: { [unowned self] in
            Defaults.initUserDefault(isIndex: true)
            Defaults.initUserDefault(isIndex: false)
            resetTrigger.onNext(true)
        }).disposed(by: disposeBag)

    }
}

extension FilterScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
}
