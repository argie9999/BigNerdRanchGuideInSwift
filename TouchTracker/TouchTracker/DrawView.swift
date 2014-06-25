//
//  DrawView.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.

import UIKit

class DrawView: UIView {
    var currentLine: Line?
    var finishedLines: Array<Line>

    init(frame: CGRect) {
        finishedLines = Array<Line>()
        currentLine = nil
        super.init(frame: frame)
        backgroundColor = UIColor.grayColor()
    }

    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = kCGLineCapRound

        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }

    override func drawRect(rect: CGRect) {
        // Draw finished lines in black
        UIColor.blackColor().set()
        for line in finishedLines {
            strokeLine(line)
        }

        // Current line is in red
        if currentLine {
            UIColor.redColor().set()
            strokeLine(currentLine!)
        }
    }

    // MARK: Touch events
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touch: AnyObject! = touches.anyObject()
        let location = touch.locationInView(self)

        currentLine = Line(begin: location, end: location)
        setNeedsDisplay()
    }

    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch: AnyObject! = touches.anyObject()
        let location = touch.locationInView(self)

        currentLine!.end = location
        setNeedsDisplay()
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        finishedLines.append(currentLine!)
        currentLine = nil

        setNeedsDisplay()
    }
}