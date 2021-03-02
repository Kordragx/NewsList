//
//  AppDelegate.swift
//  News
//
//  Created by Daniel Nunez on 27-02-21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = ViewController(nibName: "ViewController", bundle: nil)
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)

        window?.rootViewController = navController
        navController.pushViewController(vc, animated: false)
        window?.makeKeyAndVisible()

        return true
    }
}
