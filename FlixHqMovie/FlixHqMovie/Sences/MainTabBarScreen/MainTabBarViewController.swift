//
//  MainViewController.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBarItem()
    }

    private func configTabBarItem() {
        tabBar.itemWidth = 40
        tabBar.backgroundColor = UIColor.tabBarBackgroundColor
        tabBar.tintColor = UIColor.tabBarTintColor
        tabBar.unselectedItemTintColor = UIColor.tabBarUnselectedItemTintColor
    }

}
