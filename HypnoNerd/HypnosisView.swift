import UIKit

class HypnosisView: UIView {
    var circleColor: UIColor {
    didSet {
        setNeedsDisplay()
    }
    }

    init() {
        circleColor = UIColor.lightGrayColor()
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    init(frame: CGRect) {
        circleColor = UIColor.lightGrayColor()
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let bounds = self.bounds
        let maxRadius = hypot(CDouble(bounds.size.width), CDouble(bounds.size.height)) / CDouble(2.0)
        var center = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0

        // Drawing concentric circles
        for var currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20 {
            path.moveToPoint(CGPointMake(center.x + currentRadius, center.y))
            path.addArcWithCenter(center, radius: CGFloat(currentRadius),
                startAngle: 0.0, endAngle: M_PI * 2.0,clockwise: true)
        }

        path.lineWidth = 10
        circleColor.setStroke()

        // Draw the line
        path.stroke()
    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("%@ was touched", self)
        let red = CGFloat(arc4random() % 100) / CGFloat(100.0)
        let green = CGFloat(arc4random() % 100) / CGFloat(100.0)
        let blue = CGFloat(arc4random() % 100) / CGFloat(100.0)
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        circleColor = randomColor
    }
}
