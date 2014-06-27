//
//  DrawView.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.

import UIKit

extension Array {
    /** Removes the object from the array. */
    mutating func removeObject(fn: (T -> Bool)) {
        for (idx,elem) in enumerate(self) {
            if fn(elem) {
                println(elem)
                removeAtIndex(idx)
            }
        }
    }
}

class DrawView: UIView {
    var linesInProgress: Dictionary<NSValue, Line>
    var finishedLines: Array<Line>
    weak var selectedLine: Line?

    init(frame: CGRect) {
        finishedLines = Array<Line>()
        linesInProgress = Dictionary<NSValue, Line>()

        super.init(frame: frame)
        multipleTouchEnabled = true
        backgroundColor = UIColor.grayColor()

        // Double taps
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2

        // Single tap
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "singleTap:")

        // Long press gesture
        let pressRecognizer = UILongPressGestureRecognizer(target: self, action: "pressRecognizer:")

        // Add all gesture recognizers
        addGestureRecognizer(doubleTapRecognizer)
        addGestureRecognizer(singleTapRecognizer)
        addGestureRecognizer(pressRecognizer)
    }

    // Stroke the line with a Bezier Path
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = kCGLineCapRound

        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }

    // Color lines
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
            if selectedLine {
                UIColor.greenColor().set()
                strokeLine(selectedLine!)
            }
        }

        UIColor.redColor().set()
        for key in linesInProgress.keys {
            let line = linesInProgress[key]
            if line {
                strokeLine(line!)
            }
        }
    }

    // Get a Line that is close to the given point
    func lineAtPoint(point: CGPoint) -> Line? {
        for line in finishedLines {
            let start = line.begin
            let end = line.end

            // Check a few points on the line
            for var t = 0.0; t <= 1.0; t += 0.05 {
                let x = start.x + t * (end.x - start.x)
                let y = start.y + t * (end.y - start.y)
                let hypotenuse = hypot(x - point.x, y - point.y)

                // If the tapped point is within 20 points, return that line
                if hypotenuse < 20.0 {
                    return line
                }
            }
        }
        return nil
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

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    // MARK: Gesture recognizers
    func doubleTap(gesture: UITapGestureRecognizer) {
        println("Recognized a double tap")
        linesInProgress.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }

    func singleTap(gesture: UITapGestureRecognizer) {
        println("Recognized a single tap")
        let point = gesture.locationInView(self)

        // See if the user touched a line
        selectedLine = lineAtPoint(point)

        // Show a action menu bar when user selects a line
        if selectedLine {
            // Make ourselves the target of menu item action messages
            becomeFirstResponder()
            let menu = UIMenuController.sharedMenuController()
            let deleteItem = [UIMenuItem(title: "Delete", action: "deleteLine:")]
            menu.menuItems = deleteItem

            // Tell the menu where it should show itself
            menu.setTargetRect(CGRectMake(point.x, point.y, 2, 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        }
        else {
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: true)
        }

        setNeedsDisplay()
    }

    func pressRecognizer(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            let point = gesture.locationInView(self)
            selectedLine = lineAtPoint(point)

            if selectedLine {
                linesInProgress.removeAll(keepCapacity: false)
            }
        }
        else if gesture.state == .Ended {
            selectedLine = nil
        }
        setNeedsDisplay()
    }

    // MARK: Selectors
    func deleteLine(sender: AnyObject) {
        finishedLines.removeObject() {$0 == self.selectedLine}
        selectedLine = nil
        setNeedsDisplay()
    }
}