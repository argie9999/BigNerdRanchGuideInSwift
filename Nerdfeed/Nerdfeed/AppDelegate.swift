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
        didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        let cvc = CoursesViewController(style: .Plain)
        let navController = UINavigationController(rootViewController: cvc)
        window!.rootViewController = navController

        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()

        return true
    }
}