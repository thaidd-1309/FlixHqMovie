//
//  DownloadViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then

final class DownloadViewController: UIViewController {
    @IBOutlet private weak var noticeEmptyListContainerView: UIView!
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconSearchButton: UIButton!
    @IBOutlet private weak var movieTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let deleteMovieTrigger = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        bindViewModel()
        noticeEmptyListContainerView.isHidden = true
        movieTableView.isHidden = true
        searchBar.isHidden = true
        emptyImageView.image = customImage(imageName: .emptyDownload)
        movieTableView.isHidden = false
    }

    private func configTableView() {
        movieTableView.then {
            $0.register(nibName: MovieTableViewCell.self)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }
    }

    private func customImage(imageName: CustomImageName) -> UIImage {
        guard let image = UIImage(named: imageName.name) else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(
            configureCell: {  _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.defaultReuseIdentifier, for: indexPath) as? MovieTableViewCell
                else {
                    return UITableViewCell()
            }
                cell.deleteButtonTapped = { [unowned self] id in
                    deleteMovieTrigger.onNext(id)
                    let vc = DeleteMovieViewController()
                    vc.modalPresentationStyle = .pageSheet
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium(), .medium()]
                      }
                    self.present(vc, animated: true)
                }
                return cell
            })
        // TODO: Fake data, because api is Error, so will update when api is fixed
        Driver.of([1, 2, 3, 4, 5, 6, 7, 8, 9])
            .map { [SectionModel(model: "", items: $0)] }
            .drive(movieTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
}
