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
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .explore:
            return "Explore"
        case .myList:
            return "My List"
        case .download:
            return "My Download"
        case .profile:
            return "Profile"
            
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .explore:
            return UIImage(systemName: "safari")
        case .myList:
            return UIImage(systemName: "list.and.film")
        case .download:
            return UIImage(systemName: "square.and.arrow.down")
        case .profile:
            return UIImage(systemName: "person.fill")
        }
    }

    var tag:Int {
        switch self {
        case .home:
            return 0
        case .explore:
            return 1
        case .myList:
            return 2
        case .download:
            return 3
        case .profile:
            return 4

        }
    }

}
