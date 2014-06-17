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
        var screenRect = self.window!.bounds
        var bigRect = screenRect
        bigRect.size.width *= 2.0

        // Create a screen sized scroll
        let scrollView = UIScrollView(frame: screenRect)
        scrollView.pagingEnabled = true
        self.window!.addSubview(scrollView)

        // Add a screen sized Hypnosis view and add it to the scroll view
        let hypnosisView = HypnosisView(frame: screenRect)
        scrollView.addSubview(hypnosisView)

        // Add a second screen-sized hypnosis view
        screenRect.origin.x += screenRect.size.width
        let anotherView = HypnosisView(frame: screenRect)
        scrollView.addSubview(anotherView)

        // Scroll view == bigRect's size
        scrollView.contentSize = bigRect.size

        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        return true
    }
}