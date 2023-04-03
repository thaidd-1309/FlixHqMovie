//
//  SeeMoreCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 03/04/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

struct SeeMoreCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    let useCase = HomeUseCase(mediaRepository: MediaRepository())
    var type: TableHeaderRowType
    init(navigationController: BaseNavigationController, type: TableHeaderRowType) {
        self.navigationController = navigationController
        self.type = type
    }

    func toSeeMoreViewController() {
        let viewController = SeeMoreViewController()
        let viewModel = SeeMoreViewModel(coordinator: self, useCase: useCase, seeMoreType: type)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func toMovieDetail(with id: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id)
        detailCoordinator.toMovieDetailViewController()
    }
}
