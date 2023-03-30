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
    var previousTimeWatch: Double
    let useCase = DetailUseCase(mediaRepository: MediaRepository())

    init(navigationController: BaseNavigationController, mediaId: String, previousTimeWatch: Double = 0.0) {
        self.navigationController = navigationController
        self.mediaId = mediaId
        self.previousTimeWatch = previousTimeWatch
    }

    func toMovieDetailViewController() {
        let viewController = MovieDetailViewController()
        let viewModel = DetailViewModel(coordinator: self, useCase: useCase, previousTimeWatch: previousTimeWatch, mediaId: mediaId)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func toOtherDetailViewController(with id: String) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, mediaId: id)
        detailCoordinator.toMovieDetailViewController()
    }

    func toNoticeViewController(notice: String) {
        let popUpViewController = PopUpViewController()
        popUpViewController.bind(notice: notice)
        navigationController.pushViewController(popUpViewController, animated: true)
    }
}
