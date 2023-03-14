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
            MoveToViewController().toHomeScreenViewController(),
            MoveToViewController().toExploreScreenViewController(),
            MoveToViewController().toMyListScreenViewController(),
            MoveToViewController().toDownloadScreenViewController(),
            MoveToViewController().toProfileScreenViewController()
        ]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
}
