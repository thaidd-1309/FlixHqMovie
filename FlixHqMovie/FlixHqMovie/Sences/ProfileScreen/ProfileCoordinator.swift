//
//  ProfileCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct ProfileCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    let useCase = ProfileUseCase()
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toProfileViewController() {
        let viewController = ProfileViewController()
        let viewModel = ProfileViewModel(coordinator: self, useCase: useCase)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func backToLoginScreen() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        guard let rootNavigationController = window.rootViewController as? UINavigationController else { return }
        rootNavigationController.popToRootViewController(animated: true)

    }

}
