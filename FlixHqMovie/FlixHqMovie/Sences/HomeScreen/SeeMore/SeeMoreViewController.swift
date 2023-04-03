//
//  SeeMoreViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 03/04/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class SeeMoreViewController: UIViewController {

    @IBOutlet private weak var loadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var mediaCollectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private var isLoading = false
    var viewModel: SeeMoreViewModel!

    private let selectedMovieTrigger = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configMediaCollectionView()
        bindViewModel()
    }

    private func configMediaCollectionView() {
        mediaCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        mediaCollectionView.register(nibName: ImageFilmCollectionViewCell.self)

        mediaCollectionView.rx.modelSelected(MediaResult.self)
            .subscribe(onNext: { [unowned self] item in
                selectedMovieTrigger.onNext("\(item.id ?? "")")
            })
            .disposed(by: disposeBag)
    }

    private func configHiddenView(isHiddenView: Bool) {
        mediaCollectionView.isHidden = !isHiddenView
        loadActivityIndicator.isHidden = isHiddenView
    }

    private func bindViewModel() {
        let loadTrigger = Driver.just(())
        loadTrigger
            .drive(onNext: { [unowned self]_ in
                isLoading = true
            })
            .disposed(by: disposeBag)
        let input = SeeMoreViewModel.Input(loadTrigger: loadTrigger.asDriver(onErrorDriveWith: .empty()),
                                           slectedMovie: selectedMovieTrigger.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input: input, disposeBag: disposeBag)

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MediaResult>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let url = item.image ?? ""
                cell.bind(imageUrl: url)
                return cell
            }
        )

        output.medias.map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(mediaCollectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        output.isLoading
            .drive(onNext: { [unowned self] isLoading in
                configHiddenView(isHiddenView: !isLoading)
            })
            .disposed(by: disposeBag)

        output.title.drive(onNext: { [unowned self] name in
            title = name
        })
        .disposed(by: disposeBag)
    }
}

extension SeeMoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - LayoutCell.paddingWidth.value, height: collectionView.frame.size.height / 3 + LayoutCell.paddingHeight.value)
    }
}
