//
//  MovieTableViewCell.swift
//  FlixHqMovie
//
//  Created by DuyThai on 30/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieTableViewCell: UITableViewCell, ReuseCellType {

    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieCapacityLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private  weak var deleteButton: UIButton!

    var deleteButtonTapped: ((String) -> Void)?


    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        deleteButton.rx.tap.subscribe(onNext: { [unowned self] in
            deleteButtonTapped?("ss")
        })
        .disposed(by: disposeBag)
    }

    private func configView() {
        movieImageView.layer.cornerRadius = LayoutOptions.itemPoster.cornerRadious
        movieImageView.layer.borderWidth = LayoutOptions.itemPoster.borderWidth
        movieImageView.layer.borderColor = UIColor.tabBarUnselectedItemTintColor.cgColor
        playImageView.applyCircleView()
    }
}
