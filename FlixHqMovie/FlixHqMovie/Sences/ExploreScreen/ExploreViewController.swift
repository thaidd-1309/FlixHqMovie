//
//  ExploreViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ExploreViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterButtton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var notFoundImageView: UIImageView!
    @IBOutlet private weak var notFoundContainerView: UIView!
    @IBOutlet private weak var noticeNotFoundLabel: UILabel!
    @IBOutlet private weak var notFoundLabel: UILabel!

    private var disposeBag = DisposeBag()
    var viewModel: ExploreViewModel!

    private var filterTrigger = BehaviorRelay<[FilterSectionModel]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButtton.layer.cornerRadius = LayoutOptions.filterButtton.cornerRadious
        configStartView()
        configSearchBar()
    }

    private func configStartView() {
        notFoundImageView.image = customImage(imageName: .search)
        notFoundImageView.tintColor = UIColor.imageNotFoundTintColor
        noticeNotFoundLabel.text = SearchNotice.startNotice.text
        notFoundLabel.text = SearchNotice.startLabel.text
        notFoundLabel.textColor = .white
        collectionView.isHidden = true
    }

    private func customImage(imageName: CustomImageName) -> UIImage {
        guard let image = UIImage(named: imageName.name) else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    private func configSearchBar() {
        searchBar.searchTextField.backgroundColor = UIColor.searchTexFieldBackgroundColor
        actionSearchBar()
        hideKeyboardWhenTappedAround()
    }

    private func configNotFound() {
        notFoundImageView.image = customImage(imageName: .noResult)
        notFoundImageView.tintColor = UIColor.imageNotFoundTintColor
        collectionView.isHidden = true
        noticeNotFoundLabel.text = SearchNotice.notFoundNotice.text
        notFoundLabel.text = SearchNotice.notFoundLabel.text
        notFoundLabel.textColor = .red
        collectionView.isHidden = true
    }

}

extension ExploreViewController {
    func actionSearchBar() {
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            searchBar.endEditing(true)
        }).disposed(by: disposeBag)
    }
}
