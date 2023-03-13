//
//  ExploreCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct ExploreCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController

    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toExploreViewController() {
        let viewController = ExploreViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
