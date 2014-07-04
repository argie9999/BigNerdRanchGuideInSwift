//
//  WebViewController.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/3/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UISplitViewControllerDelegate {

    var toolbar: UIToolbar?

    var URL: NSURL? {
        get {
            return self.URL
        }
        set (newUrl) {
            if newUrl {
                let request = NSURLRequest(URL: newUrl)
                (view as UIWebView).loadRequest(request)
            }
        }
    }

    func goBack(sender: UIBarButtonItem) {
        println("Back button clicked")
        (view as UIWebView).goBack()
    }

    func goForward(sender: UIBarButtonItem) {
        println("Forward button clicked")
        (view as UIWebView).goForward()
    }

    override func loadView() {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        view = webView

        // Silver challenge: Add a UIToolbar instance for back and forward buttons
        toolbar = UIToolbar(frame: CGRectMake(0, 70, view.bounds.width, 44))

        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "goBack:")
        backButton.enabled = webView.canGoBack ? true : false

        let forwardButton = UIBarButtonItem(title: "Forward", style: .Plain, target: self, action: "goForward:")
        forwardButton.enabled = webView.canGoForward ? true : false

        toolbar!.items = [backButton, forwardButton]
        view.addSubview(toolbar)
    }

    // MARK: UISplitViewControllerDelegate methods

    // Note: this method is deprecated in iOS 8. 👎
    func splitViewController(svc: UISplitViewController, willHideViewController aViewController: UIViewController,
        withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController pc: UIPopoverController)
    {
        barButtonItem.title = "Courses"
        navigationItem.leftBarButtonItem = barButtonItem
    }

    // Note: this method is deprecated in iOS 8. 👎
    func splitViewController(svc: UISplitViewController, willShowViewController aViewController: UIViewController,
        withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController pc: UIPopoverController)
    {
        if barButtonItem == navigationItem.leftBarButtonItem {
            navigationItem.leftBarButtonItem = nil
        }
    }
}