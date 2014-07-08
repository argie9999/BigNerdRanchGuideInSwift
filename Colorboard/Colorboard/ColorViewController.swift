//
//  ColorViewController.swift
//  Colorboard
//
//  Created by Akshay Hegde on 7/8/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    @IBAction func dismiss(sender: UIBarButtonItem) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
