//
//  ProfileViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import RxCocoa
import RxSwift
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

struct ProfileViewModel {
    var coordinator: ProfileCoordinator
    var useCase: ProfileUseCase
    let commonTrigger = CommonTrigger.shared
    let errorTrigger = PublishSubject<LoginError>()

}

extension ProfileViewModel: ViewModelType {
    struct Input {
        var logOut: Driver<Bool>
    }

    struct Output {
        var functionTypes: Driver<[FunctionProfileType]>
        var informationGoogleUser: Driver<GIDGoogleUser?>
        var informationFaceBookUser: Driver<User?>
    }

    private func configLogOut() {
        if let user = Auth.auth().currentUser {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                LoginManager().logOut()
            } catch let signOutError as NSError {
                errorTrigger.onNext(.logOutFailed)
            }
        }

        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                GIDSignIn.sharedInstance.signOut()
            }
        }
        commonTrigger.loginGoogleStatusTrigger.onNext(false)
        commonTrigger.loginFacebookStatusTrigger.onNext(false)
        commonTrigger.userLoginFacebookTrigger.onNext(nil)
        commonTrigger.userLoginGoogleTrigger.onNext(nil)
        coordinator.backToLoginScreen()
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.logOut.drive(onNext: { isLogOut in
            if isLogOut {
                configLogOut()
            }
        })
        .disposed(by: disposeBag)
        return Output(functionTypes: useCase.getFunctionTypes().asDriver(onErrorJustReturn: []),
                      informationGoogleUser: commonTrigger.userLoginGoogleTrigger.asDriver(onErrorDriveWith: .empty()),
                      informationFaceBookUser: commonTrigger.userLoginFacebookTrigger.asDriver(onErrorDriveWith: .empty()))
    }
}
