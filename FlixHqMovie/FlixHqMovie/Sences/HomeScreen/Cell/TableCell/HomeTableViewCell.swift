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
    var movieTapped: ((String) -> Void)?

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
        updateCollectionView()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        categoryFilmLabel.text = nil
    }

    private func configCollectionView() {
        collectionView.register(nibName: ImageFilmCollectionViewCell.self)
    }

    func updateCollectionView() {
        // TODO: Fake data, will update in task/60489
        let dataTest = Observable.of([1, 2, 3, 4, 5, 6, 7, 8, 9])
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Int>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFilmCollectionViewCell.defaultReuseIdentifier, for: indexPath) as? ImageFilmCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        )
        dataTest.map {
            [SectionModel(model: "", items: $0)]
        }
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
}
