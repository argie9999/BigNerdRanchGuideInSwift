//
//  AppDelegate.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/2/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            // Override point for customization after application launch.
            let cvc = CoursesViewController(style: .Plain)
            let wvc = WebViewController()
            cvc.webViewController = wvc

            let masterNav = UINavigationController(rootViewController: cvc)

            // Initialize a SplitViewController only on an iPad
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                let detailNav = UINavigationController(rootViewController: wvc)
                let svc = UISplitViewController()

                svc.delegate = wvc
                svc.viewControllers = [masterNav, detailNav]

                window!.rootViewController = svc
            }
            else {
                window!.rootViewController = masterNav
            }

            window!.backgroundColor = UIColor.whiteColor()
            window!.makeKeyAndVisible()

            return true
    }
}
