//
//  Tabar.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation
import UIKit

enum TabbarItem {
    case home
    case explore
    case myList
    case download
    case profile

    var item: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home",
                                image: UIImage(systemName: "house.fill"),
                                tag: 0)
        case .explore:
            return UITabBarItem(title: "Explore",
                                image: UIImage(systemName: "safari"),
                                tag: 1)
        case .myList:
            return UITabBarItem(title: "My List",
                                image: UIImage(systemName: "list.and.film"),
                                tag: 2)
        case .download:
            return UITabBarItem(title: "My Download",
                                image: UIImage(systemName: "square.and.arrow.down"),
                                tag: 3)
        case .profile:
            return UITabBarItem(title: "Profile",
                                image: UIImage(systemName: "person.fill"),
                                tag: 4)
        }
    }

}
