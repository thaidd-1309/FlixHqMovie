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
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toProfileViewController() {
        let viewController = ProfileViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
