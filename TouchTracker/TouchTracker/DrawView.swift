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
        // Silver challenge: Make it so the angle at which a line is drawn 
        // dictates is color once it has been added to finishedLines

        for line in finishedLines {
            let dx = CFloat(line.end.x) - CFloat(line.begin.x)
            let dy = CFloat(line.end.y) - CFloat(line.begin.y)

            // Get the angle
            var angleInDegrees = Double(atan2f(dx, dy)) * 180 / M_PI
            if angleInDegrees < 0.0 {
                angleInDegrees += 360.0
            }
            println("Angle of line: \(angleInDegrees)")

            // Let each quadrant have its own color
            switch angleInDegrees {
            case 0..90:
                UIColor.cyanColor().set()
            case 90..180:
                UIColor.purpleColor().set()
            case 180..270:
                UIColor.yellowColor().set()
            case 270...360:
                UIColor.brownColor().set()
            default:
                UIColor.blackColor().set()
            }

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
        // println("-- Touch moved -- Class: DrawView. Method: touchesMoved")
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

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        println("-- Touch cancelled -- Class: DrawView. Method: touchesCancelled")
        let allTouches = touches.allObjects as UITouch[]

        for touch in allTouches {
            let key = NSValue(nonretainedObject: touch)
            linesInProgress.removeValueForKey(key)
        }
        setNeedsDisplay()
    }
}