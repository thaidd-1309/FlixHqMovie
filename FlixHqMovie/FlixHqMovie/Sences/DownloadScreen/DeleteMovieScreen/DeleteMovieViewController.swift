//
//  DeleteMovieViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 05/04/2023.
//

import UIKit
import RxCocoa
import RxSwift

class DeleteMovieViewController: UIViewController {
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var movieCapcityLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var movieDurationLabel: UILabel!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        congfigView()
        configButton()
    }

    private func congfigView() {
        view.layer.cornerRadius = LayoutOptions.screen.cornerRadious
        movieCapcityLabel.makeCornerRadius(radious: LayoutOptions.tagLabel.cornerRadious)
        cancelButton.layer.cornerRadius = cancelButton.frame.size.height / 2
        deleteButton.layer.cornerRadius = deleteButton.frame.size.height / 2
    }

    private func configButton() {
        deleteButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }
}
