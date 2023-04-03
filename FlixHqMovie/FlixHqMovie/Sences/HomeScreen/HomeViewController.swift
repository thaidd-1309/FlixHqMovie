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
    private let refreshControl = UIRefreshControl()
    var viewModel: HomeViewModel!

    private let selectedMovieTrigger = PublishSubject<String>()
    private let refreshTrigger = BehaviorSubject<Bool>(value: false)
    private let seeMoreTrigger = PublishSubject<TableHeaderRowType>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configTableView()
        configRefesh()
    }

    private func configHiddenView(isHiddenView: Bool) {
        tableview.isHidden = !isHiddenView
        loadingIndicator.isHidden = isHiddenView
    }
    private func configRefesh() {
        tableview.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc func refreshData(_ sender: Any) {
        refreshTrigger.onNext(true)
    }

    private func bindViewModel() {
        let loadTrigger = Driver.just(())
        loadTrigger
            .drive(onNext: { [unowned self]_ in
                isLoading = true
            })
            .disposed(by: disposeBag)

        let input = HomeViewModel.Input(loadTrigger: loadTrigger,
                                        slectedMovie: selectedMovieTrigger.asDriver(onErrorJustReturn: ""),
                                        refreshTableView: refreshTrigger.asDriver(onErrorJustReturn: false),
                                        seeMore: seeMoreTrigger.asDriver(onErrorDriveWith: .empty()))

        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TableViewSectionModel>>(
            configureCell: { [unowned self] _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.defaultReuseIdentifier, for: indexPath) as? HomeTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.setcategoryFilmLabel(headerRow: item.nameHeaderRow)
                cell.updateCollectionView(data: item.filmsSectionModel)
                cell.movieTapped = { idMovie in
                    selectedMovieTrigger.onNext(idMovie)
                }
                cell.seeMoreTapped = { nameRowType in
                    seeMoreTrigger.onNext(nameRowType)
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
        output.refreshDone.drive(onNext: { [unowned self] done in
            if done {
                refreshControl.endRefreshing()
            }
        })
        .disposed(by: disposeBag)

        output.mediaInfor.drive(onNext: { [unowned self] media in
            congfigHeaderView(mediaInfo: media)
        })
        .disposed(by: disposeBag)
    }

    private func congfigHeaderView(mediaInfo: MediaInformation?) {
        if let headerView = Bundle.main.loadNibNamed(HeaderTableView.defaultReuseIdentifier, owner: nil, options: nil)?.first as? HeaderTableView {
            let tableHeaderView = Observable<UIView?>.just(headerView)
            headerView.bind(media: mediaInfo)
            headerView.playButtonTapped = { [unowned self] idMedia in
                selectedMovieTrigger.onNext(idMedia)
            }
            tableHeaderView
                .bind(to: tableview.rx.tableHeaderView)
                .disposed(by: disposeBag)
        }
    }

    private func configTableView() {
        tableview.then {
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
            $0.contentInset = UIEdgeInsets(top: -self.topbarHeight, left: 0, bottom: 0, right: 0)
            $0.register(nibName: HomeTableViewCell.self)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableview.frame.height / 3.2
    }
}
