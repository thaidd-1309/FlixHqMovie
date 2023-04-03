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
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id)
        detailCoordinator.toMovieDetailViewController()
    }

    func toSeeMoreScreen(type: TableHeaderRowType) {
        let seeMoreCoordinator = SeeMoreCoordinator(navigationController: navigationController, type: type)
        seeMoreCoordinator.toSeeMoreViewController()
    }
}
