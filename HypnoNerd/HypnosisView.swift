import UIKit

public class HypnosisView: UIView {
    var circleColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }

    override init() {
        circleColor = UIColor.lightGrayColor()
        super.init()
        backgroundColor = UIColor.clearColor()
    }

    override init(frame: CGRect) {
        circleColor = UIColor.lightGrayColor()
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }

    public override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let bounds = self.bounds
        let maxRadius = hypot(CDouble(bounds.size.width), CDouble(bounds.size.height)) / CDouble(2.0)
        var center = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0

        // Drawing concentric circles
        for var currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20 {
            path.moveToPoint(CGPointMake(center.x + CGFloat(currentRadius), center.y))
            path.addArcWithCenter(center, radius: CGFloat(currentRadius),
                startAngle: CGFloat(0.0), endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        }

        path.lineWidth = 10
        circleColor.setStroke()

        // Draw the line
        path.stroke()
    }

    public override func touchesBegan(_: Set<NSObject>, withEvent _: UIEvent) {
        println("\(self) was touched")

        let red = CGFloat(Double(arc4random() % 100) / 100.0)
        let green = CGFloat(Double(arc4random() % 100) / 100.0)
        let blue = CGFloat(Double(arc4random() % 100) / 100)

        let randomColor = UIColor(red: red as CGFloat, green: green,
            blue: blue, alpha: 1.0)
        circleColor = randomColor
    }
}
