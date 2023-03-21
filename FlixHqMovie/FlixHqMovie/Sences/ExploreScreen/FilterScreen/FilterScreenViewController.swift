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
    
    private var needReset = false
    private let disposeBag = DisposeBag()
    private var allCategories = [FilterSectionModel]()
    private var filterDataTrigger = BehaviorRelay<[FilterSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configFilterDataSectionModel()
        configTableView()
        bindViewModel()
        configView()
    }
    
    private func configFilterDataSectionModel() {
        allCategories = [
            FilterCategory.categories.value,
            FilterCategory.regions.value,
            FilterCategory.genres.value,
            FilterCategory.periods.value,
            FilterCategory.sortOptions.value
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
    }
    
    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FilterSectionModel>>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.defaultReuseIdentifier,
                                                               for: indexPath) as? CategoryTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.bind(categories: item.data, title: item.name)
                return cell
            })
        
        Driver.of(allCategories)
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension FilterScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
}
