//
//  MainTabBarCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct MainTabBarCoordinator {
    var navigationController: BaseNavigationController

    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func toMainTabBar() {
        let tabBarController = MainTabBarViewController()
        tabBarController.viewControllers = [
            MoveToViewController().goToHomeScreenViewController(),
            MoveToViewController().goToExploreScreenViewController(),
            MoveToViewController().goToMyListScreenViewController(),
            MoveToViewController().goToDownloadScreenViewController(),
            MoveToViewController().goToProfileScreenViewController()
        ]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
}
