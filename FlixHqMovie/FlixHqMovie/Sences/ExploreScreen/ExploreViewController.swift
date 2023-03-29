//
//  ExploreViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ExploreViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterButtton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var notFoundImageView: UIImageView!
    @IBOutlet private weak var notFoundContainerView: UIView!
    @IBOutlet private weak var noticeNotFoundLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var notFoundLabel: UILabel!

    private var disposeBag = DisposeBag()
    var viewModel: ExploreViewModel!

    private var mediasTrigger = BehaviorSubject<[MediaResult]>(value: [])
    private var filterTrigger = BehaviorSubject<[FilterSectionModel]>(value: [])
    private let searchTextTrigger = PublishSubject<String>()
    private let selectedMovieTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configButtonfilter()
        configNotFound(isFound: true)
        configSearchBar()
        configCollectionView()
        bindViewModel()
    }

    private func customImage(imageName: CustomImageName) -> UIImage {
        guard let image = UIImage(named: imageName.name) else { return UIImage() }
        let whiteImage = image.withRenderingMode(.alwaysTemplate)
        return whiteImage
    }

    private func configLoadingView(isHiddenView: Bool) {
        collectionView.isHidden = !isHiddenView
        notFoundContainerView.isHidden = !isHiddenView
        loadingIndicator.isHidden = isHiddenView
    }

    private func configSearchBar() {
        searchBar.searchTextField.backgroundColor = UIColor.searchTexFieldBackgroundColor
        actionSearchBar()
        hideKeyboardWhenTappedAround()
    }

    private func configCollectionView() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        collectionView.register(nibName: ImageFilmCollectionViewCell.self)
    }

    private func configNotFound(isFound: Bool) {
        notFoundImageView.image = customImage(imageName: isFound ? .search : .noResult)
        notFoundImageView.tintColor = UIColor.imageNotFoundTintColor
        collectionView.isHidden = true
        noticeNotFoundLabel.text =  isFound ? SearchNotice.startNotice.text : SearchNotice.notFoundNotice.text
        notFoundLabel.text =  isFound ? SearchNotice.startLabel.text : SearchNotice.notFoundLabel.text
        notFoundLabel.textColor = .red
        notFoundContainerView.isHidden = false
    }

    private func bindViewModel() {
        let input = ExploreViewModel.Input(
            textInput: searchTextTrigger.asDriver(onErrorJustReturn: ""),
            slectedMovie: selectedMovieTrigger.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MediaResult>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath)
                        as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.bind(imageUrl: item.image ?? "")
                return cell
            }
        )

        output.medias
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.medias.drive(onNext: { [unowned self] medias in
            mediasTrigger.onNext(medias)
            if medias.isEmpty {
                configNotFound(isFound: false)
            } else {
                collectionView.isHidden = false
                notFoundContainerView.isHidden = true
            }
        }).disposed(by: disposeBag)

        output.isLoading.drive(onNext: {[unowned self] isLoaded in
            configLoadingView(isHiddenView: !isLoaded)
        })
        .disposed(by: disposeBag)

        configSelectedCell()
    }

    private func configSelectedCell() {
        collectionView.rx.modelSelected(MediaResult.self)
            .subscribe(onNext: { [unowned self] item in
                selectedMovieTrigger.onNext("\(item.id ?? "")")
            })
            .disposed(by: disposeBag)
    }

    private func configButtonfilter() {
        filterButtton.layer.cornerRadius = LayoutOptions.filterButtton.cornerRadious
        filterButtton.rx.tap.subscribe(onNext: {[unowned self] in
            viewModel.coordinator.toFilterViewController()
        })
        .disposed(by: disposeBag)
    }
}

extension ExploreViewController {
    func actionSearchBar() {
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            searchBar.endEditing(true)
        })
        .disposed(by: disposeBag)

        searchBar.rx.textDidEndEditing.subscribe(onNext: { [unowned self] in
            if searchBar.text == "" {
                configNotFound(isFound: true)
            } else {
                searchTextTrigger.onNext(searchBar.text?.lowercased() ?? "")
            }
        })
        .disposed(by: disposeBag)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - LayoutCell.paddingWidth.value, height: collectionView.frame.size.height / 3 + LayoutCell.paddingHeight.value)
    }
}
