//
//  MyListViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class MyListViewController: UIViewController {

    @IBOutlet private weak var noticeEmptyListContainerView: UIView!
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconSearchButton: UIButton!
    @IBOutlet private weak var mediaCollectionView: UICollectionView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    // TODO: Fake data, update in \task60498
    private let categories = ["All", "Action", "Comedy", "Romance", "Thriller", "Documentary"]
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCategoryCollectionView()
        configMediaCollectionView()
        openSearchBar(isOpened: false)
        configButton()
        configSearchBar()
        congfigEmptyList()
    }

    private func congfigEmptyList() {
        noticeEmptyListContainerView.isHidden = true
        emptyImageView.image = customImage(imageName: .emptyList)
        emptyImageView.tintColor = UIColor.imageNotFoundTintColor
    }

    private func customImage(imageName: CustomImageName) -> UIImage {
        guard let image = UIImage(named: imageName.name) else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    private func configCategoryCollectionView() {
        categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        categoryCollectionView.register(nibName: FilterCollectionViewCell.self)
        categoryCollectionView.allowsMultipleSelection = false

        let dataSoureCategory = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { [unowned self] dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? FilterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setTextInLabel(name: item)
                return cell
            }
        )

        // TODO: Fake data, update in /task60498
        Driver.of(categories).map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(categoryCollectionView.rx.items(dataSource: dataSoureCategory))
        .disposed(by: disposeBag)
    }

    private func configMediaCollectionView() {
        mediaCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        mediaCollectionView.register(nibName: ImageFilmCollectionViewCell.self)

        let dataSourceMedia = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Int>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        )

        // TODO: Fake data, update in /task60498
        Driver.of([1, 2, 3, 4, 5, 6, 7, 8]).map {
                [SectionModel(model: "", items: $0)]
            }
        .drive(mediaCollectionView.rx.items(dataSource: dataSourceMedia))
        .disposed(by: disposeBag)
    }

    private func openSearchBar(isOpened: Bool) {
        titleLabel.isHidden = isOpened
        iconSearchButton.isHidden = isOpened
        searchBar.isHidden = !isOpened
    }

    private func configButton() {
        iconSearchButton.rx.tap.subscribe(onNext: { [unowned self] in
            openSearchBar(isOpened: true)
            searchBar.becomeFirstResponder()
        })
        .disposed(by: disposeBag)
    }

    private func configSearchBar() {
        hideKeyboardWhenTappedAround()
    }
}

extension MyListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let label = UILabel()
            label.text = categories[indexPath.row]
            label.numberOfLines = 0
            let maxSize = CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let requiredSize = label.sizeThatFits(maxSize)
            let collectionViewWidth = collectionView.frame.width / 6
            let cellWidth = requiredSize.width > collectionViewWidth ? requiredSize.width : collectionViewWidth
            let cellHeight = LayoutCell.heightRatio.value * requiredSize.height
            return CGSize(width: cellWidth + LayoutCell.paddingWidth.value, height: cellHeight )
        } else {
            return CGSize(width: collectionView.frame.size.width / 2 - LayoutCell.paddingWidth.value, height: collectionView.frame.size.height / 2.4 + LayoutCell.paddingHeight.value)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            if let cell = categoryCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
                cell.configSelected(selected: true)
            }
        }
    }
}

extension MyListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        openSearchBar(isOpened: false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}
