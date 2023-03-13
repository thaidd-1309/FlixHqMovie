//
//  AppDelegate.swift
//  FlixHqMovie
//
//  Created by DuyThai on 08/03/2023.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginCoordinator: LoginCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = BaseNavigationController()
        loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator?.start()
        navigationController.isNavigationBarHidden = true
        UINavigationBar.appearance().tintColor = .white
        window?.rootViewController = navigationController
        window?.overrideUserInterfaceStyle = .dark
        window?.makeKeyAndVisible()
        return true
    }

}
