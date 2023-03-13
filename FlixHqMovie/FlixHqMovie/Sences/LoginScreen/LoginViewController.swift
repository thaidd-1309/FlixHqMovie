//
//  LoginViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn

final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginWithGoogleButton: UIButton!
    @IBOutlet private weak var loginWithFacebookButton: UIButton!
    @IBOutlet private var loginButtons: [UIButton]!
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
    }

    private func configLoginWithGoogleButton() {
        loginWithGoogleButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                viewModel.goToMainTabar()
            }).disposed(by: disposeBag)

    }

    private func configButton() {
        loginButtons.forEach {
            $0.layer.cornerRadius = UIButton.numberCornerRadius
            $0.layer.borderColor = UIColor.buttonBorderColor
            $0.layer.borderWidth = UIButton.numberBorderWidth
        }
        configLoginWithGoogleButton()
    }

}
