//
//  HomeCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct HomeCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func toHomeViewController() {
        let viewController = HomeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
