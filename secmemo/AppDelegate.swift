//
//  AppDelegate.swift
//  secmemo
//
//  Created by heximal on 08.02.2022.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationLock = UIInterfaceOrientationMask.all
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    static let container = Container()
    private var sessionService: SessionService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Container.loggingFunction = nil
        AppDelegate.container.registerDependencies()
        sessionService = AppDelegate.container.resolve(SessionService.self)!
        appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)!
        appCoordinator.start()
        return true
    }
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        sessionService?.lockSessionIfRequired()
    }
}
