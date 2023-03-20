//
//  HomeViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift
import Then

final class HomeViewController: UIViewController {
    @IBOutlet private weak var tableview: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    private let disposeBag = DisposeBag()
    private var isLoading = false
    var viewModel: HomeViewModel!

    private let playButtonInHeaderTrigger = PublishSubject<String>()
    private let selectedMovieTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configTableView()
    }

    private func configHiddenView(isHiddenView: Bool) {
        tableview.isHidden = !isHiddenView
        loadingIndicator.isHidden = isHiddenView
    }

    private func bindViewModel() {
        let loadTrigger = Driver.just(())
        loadTrigger
            .drive(onNext: { [unowned self]_ in
                isLoading = true
            })
            .disposed(by: disposeBag)

        let input = HomeViewModel.Input(loadTrigger: loadTrigger, slectedMovie: selectedMovieTrigger.asDriver(onErrorJustReturn: ""))

        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TableViewSectionModel>>(
            configureCell: { [unowned self] _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.defaultReuseIdentifier, for: indexPath) as? HomeTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.setcategoryFilmLabel(name: item.nameHeaderRow)
                cell.updateCollectionView(data: item.filmsSectionModel)
                cell.movieTapped = { idMovie in
                    selectedMovieTrigger.onNext(idMovie)
                }
                return cell
            })

        output.medias
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tableview.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.isLoading
            .drive(onNext: { [unowned self] isLoading in
                configHiddenView(isHiddenView: !isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func configTableView() {
        tableview.then {
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
            $0.contentInset = UIEdgeInsets(top: -self.topbarHeight, left: 0, bottom: 0, right: 0)
            $0.register(nibName: HomeTableViewCell.self)
        }
        if let headerView = Bundle.main.loadNibNamed(HeaderTableView.defaultReuseIdentifier, owner: nil, options: nil)?.first as? HeaderTableView {
            let tableHeaderView = Observable<UIView?>.just(headerView)
            tableHeaderView
                .bind(to: tableview.rx.tableHeaderView)
                .disposed(by: disposeBag)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableview.frame.height / 3.2
    }
}
