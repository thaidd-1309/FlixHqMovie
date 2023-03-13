//
//  DownloadCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct DownloadCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toDownloadViewController() {
        let viewController = DownloadViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
