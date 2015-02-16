//
//  AppDelegate.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // Override point for customization after application launch.
        let drawViewController = DrawViewController()
        window?.rootViewController = drawViewController
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()

        return true
    }
}

