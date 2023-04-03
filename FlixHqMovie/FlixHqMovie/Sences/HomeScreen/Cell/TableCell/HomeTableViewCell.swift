//
//  HomeTableViewCell.swift
//  MVVM_Swift
//
//  Created by DuyThai on 22/02/2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SDWebImage

final class HomeTableViewCell: UITableViewCell, ReuseCellType {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryFilmLabel: UILabel!
    @IBOutlet private weak var seeAllButton: UIButton!

    var seeMoreTapped: ((TableHeaderRowType) -> Void)?
    var movieTapped: ((String) -> Void)?
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        categoryFilmLabel.text = nil
    }

    private func configCollectionView() {
        collectionView.register(nibName: ImageFilmCollectionViewCell.self)
    }

    func setcategoryFilmLabel(headerRow: TableHeaderRowType) {
        categoryFilmLabel.text = headerRow.name

        seeAllButton.rx.tap.subscribe(onNext: { [unowned self] in
            seeMoreTapped?(headerRow)
        })
        .disposed(by: disposeBag)
    }

    func updateCollectionView(data: [MediaResult]) {
        let dataDrive = Driver.of(data)
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
        dataDrive.map {
            [SectionModel(model: "", items: $0)]
        }
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        collectionView.rx.modelSelected(MediaResult.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.movieTapped?("\(item.id ?? "")")
            })
            .disposed(by: disposeBag)
    }
}
