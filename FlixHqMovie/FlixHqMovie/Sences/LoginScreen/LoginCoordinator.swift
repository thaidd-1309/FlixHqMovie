//
//  LoginCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit
import GoogleSignIn

struct LoginCoordinator: CoordinatorProtocol {
    var childCoordinators = [CoordinatorProtocol]()

    var navigationController: UINavigationController

    func start() {
        let viewController = LoginViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToMainTabBar(googleUser: GIDGoogleUser) {
        // TO DO: Update in Task #60483
    }

}
