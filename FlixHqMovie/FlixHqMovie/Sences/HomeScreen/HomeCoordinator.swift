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
    let useCase = HomeUseCase(mediaRepository: MediaRepository())

    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func toHomeViewController() {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(coordinator: self, useCase: useCase)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func toDetailViewController(with id: String) {
        //TODO: Will updare in task 60490
    }
}
