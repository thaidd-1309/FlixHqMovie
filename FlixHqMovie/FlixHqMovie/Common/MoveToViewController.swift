//
//  BaseNavigation.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import UIKit

struct MoveToViewController {
    func toHomeScreenViewController() -> BaseNavigationController {
        let homeNavigationController = BaseNavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.toHomeViewController()
        homeNavigationController.tabBarItem = TabbarItem.home.item
        return homeNavigationController
    }

    func toExploreScreenViewController() -> BaseNavigationController {
        let exploreNavigationController = BaseNavigationController()
        let exploreCoordinator = ExploreCoordinator(navigationController: exploreNavigationController)
        exploreCoordinator.toExploreViewController()
        exploreNavigationController.tabBarItem = TabbarItem.explore.item
        return exploreNavigationController
    }

    func toMyListScreenViewController() -> BaseNavigationController {
        let mylistNavigationController = BaseNavigationController()
        let myListCoordinator = MyListCoordinator(navigationController: mylistNavigationController)
        myListCoordinator.toMyListViewController()
        mylistNavigationController.tabBarItem = TabbarItem.myList.item
        return mylistNavigationController
    }

    func toDownloadScreenViewController() -> BaseNavigationController {
        let downloadNavigationController = BaseNavigationController()
        let downloadCoordinator = DownloadCoordinator(navigationController: downloadNavigationController)
        downloadCoordinator.toDownloadViewController()
        downloadNavigationController.tabBarItem = TabbarItem.download.item
        return downloadNavigationController
    }

    func toProfileScreenViewController() -> BaseNavigationController {
        let profileNavigationController = BaseNavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.toProfileViewController()
        profileNavigationController.tabBarItem = TabbarItem.profile.item
        return profileNavigationController
    }
}
