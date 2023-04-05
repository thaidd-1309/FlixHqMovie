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
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginCoordinator: LoginCoordinator?
    let commonTrigger = CommonTrigger.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

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

    internal func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return false
    }
}
