//
//  LoginViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import RxCocoa
import RxSwift
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FBSDKCoreKit
import FBSDKLoginKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var loginWithGoogleButton: UIButton!
    @IBOutlet private weak var loginWithFacebookButton: UIButton!
    @IBOutlet private var loginButtons: [UIButton]!

    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    private let commonTrigger = CommonTrigger.shared
    private var isRecentGoogleLogin = false
    private var isRecentFacebookLogin = false

    private let loginTappedTrigger = PublishSubject<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
        bindViewModel()
        configLoginWithGoogleButton()
        configLoginWithFacebookButton()
    }

    private func configLoginWithFacebookButton() {
        loginWithFacebookButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if isRecentFacebookLogin {
                    loginTappedTrigger.onNext(true)
                } else {
                    loginWithFacebook()
                }
            })
            .disposed(by: disposeBag)
    }

    private func configLoginWithGoogleButton() {
        loginWithGoogleButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if isRecentGoogleLogin {
                    loginTappedTrigger.onNext(true)
                } else {
                    loginWithGoogle()
                }
            })
            .disposed(by: disposeBag)
    }

    private func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn( withPresenting: self) {[unowned self] signInResult, _ in
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, _ in
                if let result = result {
                    loginTappedTrigger.onNext(true)
                    commonTrigger.loginGoogleStatusTrigger.onNext(true)
                    commonTrigger.userLoginGoogleTrigger.onNext(user)
                }
            }
        }
    }

    private func loginWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [unowned self] result, _ in

            guard let token = AccessToken.current?.tokenString else {
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) { authResult, _ in
                if let authResult = authResult {
                    guard let user = Auth.auth().currentUser else {
                            return
                        }
                    loginTappedTrigger.onNext(true)
                    commonTrigger.loginFacebookStatusTrigger.onNext(true)
                    commonTrigger.userLoginFacebookTrigger.onNext(user)
                }
            }
        }
    }

    private func configButton() {
        loginButtons.forEach {
            $0.layer.cornerRadius = UIButton.numberCornerRadius
            $0.layer.borderColor = UIColor.buttonBorderColor
            $0.layer.borderWidth = UIButton.numberBorderWidth
        }
    }

    private func bindViewModel() {
        let input = LoginViewModel.Input(loginTapped: loginTappedTrigger.asDriver(onErrorJustReturn: false))
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        output.googleLogined.drive(onNext: { [unowned self] isLogin in
            isRecentGoogleLogin = isLogin
        })
        .disposed(by: disposeBag)

        output.facebookLogined.drive(onNext: { [unowned self] isLogin in
            isRecentFacebookLogin = isLogin
        })
        .disposed(by: disposeBag)
    }

}
