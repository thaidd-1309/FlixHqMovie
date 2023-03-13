//
//  LoginCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit
import GoogleSignIn

struct LoginCoordinator {
    var navigationController: BaseNavigationController

    func start() {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel(coordinator: self)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToMainTabBar() {
        let mainTabBarCooridnator = MainTabBarCoordinator(navigationController: navigationController)
        mainTabBarCooridnator.toMainTabBar()
    }

}
