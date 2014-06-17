//
//  HypnosisView.swift
//  Hypnosister
//
//  Created by Akshay Hegde on 6/16/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

class HypnosisView: UIView {
    init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let bounds = self.bounds
        let maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0
        var center = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0

        // Drawing concentric circles
        for var currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20 {
            path.moveToPoint(CGPointMake(center.x + currentRadius, center.y))
            path.addArcWithCenter(center, radius: currentRadius,
                startAngle: 0.0, endAngle: M_PI * 2, clockwise: true)
        }

        path.lineWidth = 10
        UIColor.lightGrayColor().setStroke()

        // Draw the line
        path.stroke()
    }
}
