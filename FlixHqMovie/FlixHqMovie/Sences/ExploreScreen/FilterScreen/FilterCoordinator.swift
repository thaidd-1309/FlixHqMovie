//
//  FilterScreenCoordinator.swift
//  FlixHqMovie
//
//  Created by DuyThai on 21/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct FilterCoordinator: CoordinatorType {
    var navigationController: BaseNavigationController
    let useCase = ExploreUseCase(mediaRepository: MediaRepository())

    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }

    func toFilterViewController(filterTrigger: BehaviorSubject<[FilterSectionModel]>) {
        let viewController = FilterScreenViewController()
        let viewModel = FilterViewModel(coordinator: self)
        viewController.viewModel = viewModel
        viewController.filterTrigger = filterTrigger
        navigationController.present(viewController, animated: true)
    }

}
