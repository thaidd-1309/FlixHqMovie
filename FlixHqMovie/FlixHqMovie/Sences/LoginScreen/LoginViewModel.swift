//
//  LoginViewModel.swift
//  FlixHqMovie
//
//  Created by DuyThai on 13/03/2023.
//

import Foundation

struct LoginViewModel {
    var coordinator: LoginCoordinator

    func goToMainTabar() {
        coordinator.goToMainTabBar()
    }
}
