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

    private let disposeBag = DisposeBag()
    private var categories = [String]()
    var viewModel: MyListViewModel!

    private let selectedMovieTrigger = PublishSubject<MyList>()
    private let selectedGenreTrigger = BehaviorSubject<String>(value: "All")
    private let updateMyListTrigger = BehaviorSubject<Bool>(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMyListTrigger.onNext(true)
        bindViewModel()
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
        categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        categoryCollectionView.register(nibName: FilterCollectionViewCell.self)
        categoryCollectionView.allowsMultipleSelection = false

        categoryCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [unowned self] genre in
                selectedGenreTrigger.onNext(genre)
            })
            .disposed(by: disposeBag)

        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
    }

    private func configMediaCollectionView() {
        mediaCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        mediaCollectionView.register(nibName: ImageFilmCollectionViewCell.self)

        mediaCollectionView.rx.modelSelected(MyList.self)
            .subscribe(onNext: { [unowned self] item in
                selectedMovieTrigger.onNext(item)
            })
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

extension MyListViewController {
    private func bindViewModel() {
        let input = MyListViewModel.Input(slectedMovie: selectedMovieTrigger.asDriver(onErrorDriveWith: .empty()),
                                          updateMyList: updateMyListTrigger.asDriver(onErrorJustReturn: false),
                                          selectedGenre: selectedGenreTrigger.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        output.genres.drive(onNext: { [unowned self] values in
            categories = values
        })
        .disposed(by: disposeBag)

        let dataSourceMedia = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MyList>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.bind(imageUrl: item.image)
                return cell
            }
        )

        let dataSoureCategory = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? FilterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setTextInLabel(name: item)
                return cell
            }
        )

        output.genres.map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(categoryCollectionView.rx.items(dataSource: dataSoureCategory))
        .disposed(by: disposeBag)

        output.myListModels.map {
                [SectionModel(model: "", items: $0)]
            }
        .drive(mediaCollectionView.rx.items(dataSource: dataSourceMedia))
        .disposed(by: disposeBag)

        output.myListModels.drive(onNext: {[unowned self] myListModels in
            noticeEmptyListContainerView.isHidden = !myListModels.isEmpty
        })
        .disposed(by: disposeBag)
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
