//
//  LoginCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FirebaseAuth
import Reachability

struct LoginCoordinator {
    var navigationController: BaseNavigationController
    let commonTrigger = CommonTrigger.shared
    func start() {
        updateUserAndStatusLoginTrigger()
        let viewController = LoginViewController()
        let viewModel = LoginViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToMainTabBar() {
        let mainTabBarCooridnator = MainTabBarCoordinator(navigationController: navigationController)
        mainTabBarCooridnator.toMainTabBar()
    }

    func toNoticeViewController(notice: String) {
        let popUpViewController = PopUpViewController()
        popUpViewController.bind(notice: notice)
        navigationController.pushViewController(popUpViewController, animated: true)
    }

    func updateUserAndStatusLoginTrigger() {
        // check google is logged
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            let check = (error != nil || user == nil)
            commonTrigger.loginGoogleStatusTrigger.onNext(!check)
            commonTrigger.userLoginGoogleTrigger.onNext(check ? nil : user )
        }
        
        // check facebook is logged
        if let user = Auth.auth().currentUser {
            commonTrigger.userLoginFacebookTrigger.onNext(user)
            commonTrigger.loginFacebookStatusTrigger.onNext(true)
        }
    }

    func toNetworkNoticeViewController() {
        let networkNoticteVIewController = NetworkNoticeScreenViewController()
        networkNoticteVIewController.modalPresentationStyle = .overFullScreen
        navigationController.present(networkNoticteVIewController, animated: false)
    }

}
