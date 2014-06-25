//
//  DrawViewController.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    override func loadView() {
        view = DrawView(frame: CGRectZero)
    }
}