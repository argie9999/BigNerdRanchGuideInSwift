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

        if let win = self.window {
            // Override point for customization after application launch.
            let firstFrame = CGRectMake(160, 240, 100, 150)
            let firstView  = HypnosisView(frame: firstFrame)
            firstView.backgroundColor = UIColor.redColor()
            win.addSubview(firstView)

            let secondFrame = CGRectMake(20, 30, 50, 50)
            let secondView  = HypnosisView(frame: secondFrame)
            secondView.backgroundColor = UIColor.blueColor()
            firstView.addSubview(secondView)

            win.backgroundColor = UIColor.whiteColor()
            win.makeKeyAndVisible()
        }
        return true
    }
}