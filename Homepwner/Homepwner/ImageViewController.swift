//
//  ImageViewController.swift
//  Homepwner
//
//  Created by ajh17 on 7/1/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var image: UIImage?

    override func loadView() {
        let imageView = UIImageView()
        view = imageView

        // Gold challenge: Add Zooming to ImageViewController and center the image.
        view.contentMode = .Center
        view.userInteractionEnabled = true
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "zoom:")
        view.addGestureRecognizer(pinchRecognizer)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Cast the view to UIImageView so the compiler knows it
        let imageView = view as UIImageView
        imageView.image = image
    }

    func zoom(gesture: UIPinchGestureRecognizer) {
        view.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale)
    }
}
