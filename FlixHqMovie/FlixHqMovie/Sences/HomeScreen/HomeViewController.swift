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

    private let disposeBag = DisposeBag()

    private let playButtonInHeaderTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configTableView()
    }

    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FakeSectionModel>>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.defaultReuseIdentifier, for: indexPath) as? HomeTableViewCell
                else {
                    return UITableViewCell()
                }
                return cell
            })
        //TODO: Fake data, will update in task/60489
        let dataTestSection = FakeSectionModel(
            nameHeaderRow: "Popular",
            filmsSectionModel: [1, 2, 3, 4, 5])

        Driver.of(dataTestSection)
            .map{ [SectionModel(model: "", items: [$0, $0, $0, $0])] }
            .drive(tableview.rx.items(dataSource: dataSource))
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
