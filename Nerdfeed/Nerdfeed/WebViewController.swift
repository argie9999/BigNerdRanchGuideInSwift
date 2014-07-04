//
//  WebViewController.swift
//  Nerdfeed
//
//  Created by Akshay Hegde on 7/3/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

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

    override func loadView() {
        let webView = UIWebView()
        webView.scalesPageToFit = true
        view = webView
    }
}