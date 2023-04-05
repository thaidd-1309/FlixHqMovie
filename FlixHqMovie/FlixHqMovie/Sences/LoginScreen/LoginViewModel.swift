//
//  LoginViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import RxCocoa
import RxSwift
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

struct LoginViewModel {
    var coordinator: LoginCoordinator
    let commonTrigger = CommonTrigger.shared
}

extension LoginViewModel: ViewModelType {
    struct Input {
        let loginTapped: Driver<Bool>
    }

    struct Output {
        let googleLogined: Driver<Bool>
        let facebookLogined: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {

        input.loginTapped.drive(onNext: { login in
            if login {
                coordinator.goToMainTabBar()
            }
        })
        .disposed(by: disposeBag)

        return Output(googleLogined: commonTrigger.loginGoogleStatusTrigger.asDriver(onErrorJustReturn: false),
                      facebookLogined: commonTrigger.loginFacebookStatusTrigger.asDriver(onErrorJustReturn: false))
    }
}
