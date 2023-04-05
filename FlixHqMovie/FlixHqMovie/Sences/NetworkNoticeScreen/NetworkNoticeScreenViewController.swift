//
//  NetworkNoticeScreenViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 05/04/2023.
//

import UIKit
import Reachability
import RxSwift
import RxCocoa
import Then

class NetworkNoticeScreenViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tryAgainButton: UIButton!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var noticeImageView: UIImageView!

    private var isConnected = false
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        checkConnection()
        configButton()
    }

    private func configView() {
        containerView.then {
            $0.layer.cornerRadius = LayoutOptions.containerView.cornerRadious
            $0.layer.borderWidth = LayoutOptions.containerView.borderWidth
            $0.layer.borderColor = UIColor.borderColorFilterCell
        }
    }

    private func configButton() {
        tryAgainButton.rx.tap.subscribe(onNext: { [unowned self] in
            if isConnected {
                self.dismiss(animated: true)
            }
        })
        .disposed(by: disposeBag)
    }

    private func updateView(connectionType: Reachability.Connection) {
        messageLabel.text = connectionType.message
        titleLabel.text = connectionType.title
        noticeImageView.image = connectionType.image
        noticeImageView.tintColor = .blue

        switch connectionType {
        case .none:
            isConnected = false
        case .unavailable:
            isConnected = false
        case .wifi:
            isConnected = true
        case .cellular:
            isConnected = true
        }
    }

    private func checkConnection () {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate { 
            appDelegate.connectionRelay
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] connection in
                    updateView(connectionType: connection)
                })
                .disposed(by: disposeBag)
        }
    }
}
