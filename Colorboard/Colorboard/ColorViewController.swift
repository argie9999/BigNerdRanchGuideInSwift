//
//  ColorViewController.swift
//  Colorboard
//
//  Created by Akshay Hegde on 7/8/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var textfield: UITextField?
    @IBOutlet weak var redSlider: UISlider?
    @IBOutlet weak var greenSlider: UISlider?
    @IBOutlet weak var blueSlider: UISlider?

    // MARK: Stored Properties
    var existingColor: Bool = false
    var colorDescription: ColorDescription?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Remove the done button if this is an existing color
        if existingColor {
            navigationItem.rightBarButtonItem = nil
        }
    }

    override func viewDidLoad() {
        if let colorDesc = colorDescription {
            let color = colorDesc.color
            var red = CGFloat(0)
            var blue = CGFloat(0)
            var green = CGFloat(0)
            var alpha = CGFloat(0)

            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            // Set the initial slider values
            redSlider!.value = Float(red)
            greenSlider!.value = Float(green)
            blueSlider!.value = Float(blue)

            // Set the background color and text field value
            view.backgroundColor = color
            textfield!.text = colorDesc.name
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let colorDesc = colorDescription {
            colorDesc.name = textfield!.text
            colorDesc.color = view.backgroundColor
        }
    }

    // MARK: Actions

    @IBAction func dismiss(sender: UIBarButtonItem) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func changeColor(sender: UISlider) {
        let red = CGFloat(redSlider!.value)
        let green = CGFloat(greenSlider!.value)
        let blue = CGFloat(blueSlider!.value)

        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
