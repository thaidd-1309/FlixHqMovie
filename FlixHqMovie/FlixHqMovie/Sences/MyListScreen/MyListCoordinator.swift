//
//  MyListCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import Foundation
import UIKit

struct MyListCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    let useCase = MyListUseCase(mediaRepository: MediaRepository())
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toMyListViewController() {
        let viewController = MyListViewController()
        let viewModel = MyListViewModel(coordinator: self, useCase: useCase)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func toMovieDetail(with id: String, previousTime: Double) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id, previousTimeWatch: previousTime)
        detailCoordinator.toMovieDetailViewController()
    }

    func toNoticeViewController(notice: String) {
        let popUpViewController = PopUpViewController()
        popUpViewController.bind(notice: notice)
        navigationController.pushViewController(popUpViewController, animated: true)
    }
}
