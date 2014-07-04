//
//  WebViewController.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/3/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

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
        if (view as UIWebView).canGoBack {
            (view as UIWebView).goBack()
        }
    }

    func goForward(sender: UIBarButtonItem) {
        println("Forward button clicked")
        if (view as UIWebView).canGoForward {
            (view as UIWebView).goForward()
        }
    }

    override func loadView() {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        view = webView

        // Silver challenge: Add a UIToolbar instance for back and forward buttons
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "goBack:")
        let forwardButton = UIBarButtonItem(title: "Forward", style: .Plain, target: self, action: "goForward:")
        toolbar = UIToolbar(frame: CGRectMake(0, 70, view.bounds.width, 44))
        toolbar!.items = [backButton, forwardButton]

        view.addSubview(toolbar)
    }
}