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
        navigationController.pushViewController(viewController, animated: true)
    }

    func toMovieDetail(with id: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id)
        detailCoordinator.toMovieDetailViewController()
    }
}
