//
//  DetailCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 17/03/2023.
//

import Foundation

struct DetailCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    var mediaId: String
    let useCase = DetailUseCase(mediaRepository: MediaRepository())

    init(navigationController: BaseNavigationController, mediaId: String) {
        self.navigationController = navigationController
        self.mediaId = mediaId
    }

    func toMovieDetailViewController() {
        let viewController = MovieDetailViewController()
        let viewModel = DetailViewModel(coordinator: self, useCase: useCase, mediaId: mediaId)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func toOtherDetailViewController(with id: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id)
        detailCoordinator.toMovieDetailViewController()
    }
}
