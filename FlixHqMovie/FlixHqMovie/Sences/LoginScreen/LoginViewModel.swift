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
        let connectionNetwork: Driver<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let connectionNetworkTrigger = PublishSubject<Bool>()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.connectionRelay
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { connection in
                    switch connection {
                    case .unavailable:
                        connectionNetworkTrigger.onNext(false)
                    case .wifi:
                        connectionNetworkTrigger.onNext(true)
                    case .cellular:
                        connectionNetworkTrigger.onNext(true)
                        break
                    case .none:
                        connectionNetworkTrigger.onNext(false)
                    }
                })
                .disposed(by: disposeBag)
        }

        input.loginTapped.drive(onNext: { login in
            if login {
                coordinator.goToMainTabBar()
            }
        })
        .disposed(by: disposeBag)

        return Output(googleLogined: commonTrigger.loginGoogleStatusTrigger.asDriver(onErrorJustReturn: false),
                      facebookLogined: commonTrigger.loginFacebookStatusTrigger.asDriver(onErrorJustReturn: false),
                      connectionNetwork: connectionNetworkTrigger.asDriver(onErrorJustReturn: false))
    }
}
