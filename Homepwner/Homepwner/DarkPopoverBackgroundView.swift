//
//  DarkPopoverBackgroundView.swift
//  Homepwner
//
//  Created by ajh17 on 6/30/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//
// Gold challenge: Change Popover Appearance
// Currently does not work. Maybe an experimental thing in iOS 8? Or maybe I did something wrong...

import UIKit

class DarkPopoverBackgroundView: UIPopoverBackgroundView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        println("Using custom dark background for UIPopoverController.")
        self.frame = frame
        backgroundColor = UIColor.blackColor()
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    override class func wantsDefaultContentAppearance() -> Bool {
        return false
    }
}