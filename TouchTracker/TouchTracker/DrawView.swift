//
//  DrawView.swift
//  TouchTracker
//
//  Created by ajh17 on 6/25/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.

import UIKit

extension Array {
    /**
    Removes the object from the array.
    */
    mutating func removeObject(fn: (T -> Bool)) {
        for (idx,elem) in enumerate(self) {
            if fn(elem) {
                removeAtIndex(idx)
            }
        }
    }
}

class DrawView: UIView, UIGestureRecognizerDelegate {
    // MARK: Line related variables
    var linesInProgress: Dictionary<NSValue, Line>
    var finishedLines: Array<Line>
    weak var selectedLine: Line?

    // MARK: Gesture recognizers
    let moveRecognizer: UIPanGestureRecognizer?
    let threeFingerRecognizer: UISwipeGestureRecognizer?

    // MARK: Color Palette related outlets and variable
    @IBOutlet weak var darkBlueColor: UIButton
    @IBOutlet weak var lightBlueColor: UIButton
    @IBOutlet weak var magentaColor: UIButton
    @IBOutlet weak var lightPurpleColor: UIButton
    @IBOutlet weak var greenColor: UIButton
    @IBOutlet weak var yellowColor: UIButton
    @IBOutlet var colorPaletteView: UIView?
    var selectedColor: UIColor?

    // Needed for loading a nib
    init(coder aDecoder: NSCoder!) {
        finishedLines = Array<Line>()
        linesInProgress = Dictionary<NSValue, Line>()
        super.init(coder: aDecoder)
    }

    init(frame: CGRect) {
        finishedLines = Array<Line>()
        linesInProgress = Dictionary<NSValue, Line>()
        super.init(frame: frame)

        // Double taps
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2

        // Single tap
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "singleTap:")

        // Long press gesture
        let pressRecognizer = UILongPressGestureRecognizer(target: self, action: "pressRecognizer:")

        // Pan gesture
        moveRecognizer = UIPanGestureRecognizer(target: self, action: "moveLine:")
        moveRecognizer!.delegate = self
        moveRecognizer!.cancelsTouchesInView = false

        // Three finger swipe gesture
        threeFingerRecognizer = UISwipeGestureRecognizer(target: self, action: "showColorPalette:")
        threeFingerRecognizer!.delegate = self
        threeFingerRecognizer!.cancelsTouchesInView = true
        threeFingerRecognizer!.numberOfTouchesRequired = 3
        threeFingerRecognizer!.direction = .Up

        // Add all gesture recognizers
        addGestureRecognizer(doubleTapRecognizer)
        addGestureRecognizer(singleTapRecognizer)
        addGestureRecognizer(pressRecognizer)
        addGestureRecognizer(moveRecognizer!)
        addGestureRecognizer(threeFingerRecognizer!)

        multipleTouchEnabled = true
        backgroundColor = UIColor.grayColor()
    }

    // Stroke the line with a Bezier Path
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = line.thickness
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
            if !selectedColor {
                let dx = CFloat(line.end.x) - CFloat(line.begin.x)
                let dy = CFloat(line.end.y) - CFloat(line.begin.y)

                // Get the angle
                var angleInDegrees = Double(atan2f(dx, dy)) * 180 / M_PI
                if angleInDegrees < 0.0 {
                    angleInDegrees += 360.0
                }

                // Let each quadrant have its own color
                switch angleInDegrees {
                case 0..90:
                    line.color = UIColor.cyanColor()
                case 90..180:
                    line.color = UIColor.purpleColor()
                case 180..270:
                    line.color = UIColor.yellowColor()
                case 270...360:
                    line.color = UIColor.brownColor()
                default:
                    line.color = UIColor.blackColor()
                }
            }
            line.color.set()
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

        // If color palette is active, don't draw lines. i.e. wait for user to select a color.
        if colorPaletteView { return }

        // If the delete menu is active, don't do anything
        // Silver challenge: Mysterious lines bug
        if UIMenuController.sharedMenuController().menuVisible {
            return
        }
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

                // Gold challenge: Speed and Size: Adjust line thickness to match velocity
                let velocityInVew = moveRecognizer!.velocityInView(self)
                let rawVelocity = hypot(velocityInVew.x, velocityInVew.y)
                switch rawVelocity {
                case let vel where vel > 5000.0:
                    line!.thickness = 20.0
                case let vel where vel > 3000.0:
                    line!.thickness = 10.0
                case let vel where vel > 2000.0:
                    line!.thickness = 8.0
                case let vel where vel > 1000.0:
                    line!.thickness = 5.0
                case let vel where vel > 500.0:
                    line!.thickness = 3.0
                case let vel where vel > 200.0:
                    line!.thickness = 2.0
                default:
                    line!.thickness = 1.0
                }
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
                if selectedColor {
                    line!.color = selectedColor!
                }
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
        selectedColor = nil  // Also reset the current selected color
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
        println("Detected long press gesture")
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

    // MARK: Gesture recognizers.
    func deleteLine(sender: AnyObject) {
        finishedLines.removeObject() {$0 == self.selectedLine}
        selectedLine = nil
        setNeedsDisplay()
    }

    func moveLine(gesture: UIPanGestureRecognizer) {
        // If a line is not selected, or if the delete menu is active, don't do anything
        // Silver challenge: mysterious lines bug.
        if selectedLine == nil || UIMenuController.sharedMenuController().menuVisible {
            return
        }

        if gesture.state == .Changed {
            // How far has the pan moved?
            let translation = gesture.translationInView(self)
            var begin = selectedLine!.begin
            var end = selectedLine!.end

            begin.x += translation.x
            begin.y += translation.y
            end.x += translation.x
            end.y += translation.y

            selectedLine!.begin = begin
            selectedLine!.end = end
            setNeedsDisplay()
            gesture.setTranslation(CGPointZero, inView: self)
        }
    }

    func showColorPalette(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .Began && !colorPaletteView {
            colorPaletteView = NSBundle.mainBundle().loadNibNamed("ColorPaletteView", owner: self, options: nil)[0] as? UIView
            if colorPaletteView {
                println("Color Palette shown.")
                colorPaletteView!.frame = CGRectMake(0, bounds.height, bounds.width, 50)
                addSubview(colorPaletteView!)
                UIView.animateWithDuration(0.2, delay: 0.2, options: .CurveEaseIn, animations: {
                    self.colorPaletteView!.frame = CGRectMake(0, self.bounds.height - 50, self.bounds.width, 50)
                    }, completion: nil)
                UIView.commitAnimations()
            }
        }
    }

    // MARK: IBActions

    /**
    Select the color and dismiss the color palette.
    */
    @IBAction func didSelectColorInColorPalette(sender: UIButton) {
        selectedColor = sender.backgroundColor
        println("Selected a color: \(selectedColor)")
        colorPaletteView!.removeFromSuperview()
        colorPaletteView = nil
    }

    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool
    {
        if gestureRecognizer == moveRecognizer {
            return true
        }
        return false
    }
}
