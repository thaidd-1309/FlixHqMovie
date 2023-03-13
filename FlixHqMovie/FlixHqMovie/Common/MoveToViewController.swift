//
//  BaseNavigation.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import UIKit

struct MoveToViewController {
    func goToHomeScreenViewController() -> BaseNavigationController {
        let homeNavigationController = BaseNavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.toHomeViewController()
        homeNavigationController.tabBarItem = UITabBarItem(title: TabbarItem.home.title, image: TabbarItem.home.image, tag: TabbarItem.home.tag)
        return homeNavigationController
    }

    func goToExploreScreenViewController() -> BaseNavigationController {
        let exploreNavigationController = BaseNavigationController()
        let exploreCoordinator = ExploreCoordinator(navigationController: exploreNavigationController)
        exploreCoordinator.toExploreViewController()
        exploreNavigationController.tabBarItem = UITabBarItem(title: TabbarItem.explore.title, image: TabbarItem.explore.image, tag: TabbarItem.explore.tag)
        return exploreNavigationController
    }

    func goToMyListScreenViewController() -> BaseNavigationController {
        let mylistNavigationController = BaseNavigationController()
        let myListCoordinator = MyListCoordinator(navigationController: mylistNavigationController)
        myListCoordinator.toMyListViewController()
        mylistNavigationController.tabBarItem = UITabBarItem(title: TabbarItem.myList.title, image: TabbarItem.myList.image, tag: TabbarItem.myList.tag)
        return mylistNavigationController
    }

    func goToDownloadScreenViewController() -> BaseNavigationController {
        let downloadNavigationController = BaseNavigationController()
        let downloadCoordinator = DownloadCoordinator(navigationController: downloadNavigationController)
        downloadCoordinator.toDownloadViewController()
        downloadNavigationController.tabBarItem = UITabBarItem(title: TabbarItem.download.title, image: TabbarItem.download.image, tag: TabbarItem.download.tag)
        return downloadNavigationController
    }

    func goToProfileScreenViewController() -> BaseNavigationController {
        let profileNavigationController = BaseNavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.toProfileViewController()
        profileNavigationController.tabBarItem = UITabBarItem(title: TabbarItem.profile.title, image: TabbarItem.profile.image, tag: TabbarItem.profile.tag)
        return profileNavigationController
    }
}
