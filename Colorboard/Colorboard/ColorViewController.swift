//
//  ColorViewController.swift
//  Colorboard
//
//  Created by Akshay Hegde on 7/8/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField
    @IBOutlet weak var redSlider: UISlider
    @IBOutlet weak var greenSlider: UISlider
    @IBOutlet weak var blueSlider: UISlider

    @IBAction func dismiss(sender: UIBarButtonItem) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func changeColor(sender: UISlider) {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)

        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
