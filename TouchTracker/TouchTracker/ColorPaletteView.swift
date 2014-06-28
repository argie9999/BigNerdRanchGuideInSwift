//
//  ColorPaletteView.swift
//  TouchTracker
//
//  Created by ajh17 on 6/28/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {
    @IBOutlet weak var darkBlueColor: UIButton
    @IBOutlet weak var lightBlueColor: UIButton
    @IBOutlet weak var magentaColor: UIButton
    @IBOutlet weak var lightPurpleColor: UIButton
    @IBOutlet weak var greenColor: UIButton
    @IBOutlet weak var yellowColor: UIButton
    @IBOutlet var colorPaletteView: UIView

    var selectedColor: UIColor?  // The current selected Color.

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect) {
        selectedColor = nil
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("ColorPaletteView", owner: self, options: nil)
        addSubview(colorPaletteView)
    }

    // MARK: IBActions
    @IBAction func darkBlueSelected(sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
    @IBAction func cyanColorSelected(sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
    @IBAction func magentaColorSelected(sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
    @IBAction func greenColorSelected(sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
    @IBAction func yellowColorSelected(sender: UIButton) {
        selectedColor = sender.backgroundColor
    }
}
