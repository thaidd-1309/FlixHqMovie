//
//  PopUpViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 29/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class PopUpViewController: UIViewController {
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var titileNoticeLabel: UILabel!
    @IBOutlet private weak var gotItButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    private func configView() {
        gotItButton.layer.cornerRadius = gotItButton.frame.size.height / 2
    }

    private func configButton() {
        gotItButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }

    func bind(notice: String) {
        noticeLabel.text = notice
    }
}
