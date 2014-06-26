//
//  DrawView.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.

import UIKit

class DrawView: UIView {
    var linesInProgress: Dictionary<NSValue, Line>
    var finishedLines: Array<Line>

    init(frame: CGRect) {
        finishedLines = Array<Line>()
        linesInProgress = Dictionary<NSValue, Line>()

        super.init(frame: frame)
        multipleTouchEnabled = true
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

        UIColor.redColor().set()
        for key in linesInProgress.keys {
            let line = linesInProgress[key]
            if line {
                strokeLine(line!)
            }
        }
    }

    // MARK: Touch events
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        println("-- Touch started -- Class: DrawView. Method: touchesBegan")
        let allTouches = touches.allObjects as UITouch[]

        for touch in allTouches {
            let location = touch.locationInView(self)

            let line = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            linesInProgress[key] = line
        }
        setNeedsDisplay()
    }

    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        println("-- Touch moved -- Class: DrawView. Method: touchesMoved")
        let allTouches = touches.allObjects as UITouch[]

        for touch in allTouches {
            let key = NSValue(nonretainedObject: touch)
            let line = linesInProgress[key]
            if line {
                line!.end = touch.locationInView(self)
            }
        }
        setNeedsDisplay()
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        println("-- Touch ended -- Class: DrawView. Method: touchesEnded")
        let allTouches = touches.allObjects as UITouch[]

        for touch in allTouches {
            let key = NSValue(nonretainedObject: touch)
            let line = linesInProgress[key]

            if line {
                finishedLines += line!
                linesInProgress.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
}