//
//  LoginViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxSwift
import GoogleSignIn

final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginWithGoogleButton: UIButton!
    @IBOutlet private weak var loginWithFacebookButton: UIButton!
    @IBOutlet private var loginButtons: [UIButton]!
    var coordinator: CoordinatorProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
    }

    private func configButton() {
        loginButtons.forEach {
            $0.layer.cornerRadius = UIButton.numberCornerRadius
            $0.layer.borderColor = UIColor.buttonBorderColor
            $0.layer.borderWidth = UIButton.numberBorderWidth
        }
    }

}
