//
//  AppDelegate.swift
//  Hypnosister
//
//  Created by Akshay Hegde on 6/16/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // Override point for customization after application launch.
        let firstFrame = self.window!.bounds
        let firstView  = HypnosisView(frame: firstFrame)
        self.window!.addSubview(firstView)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        return true
    }
}