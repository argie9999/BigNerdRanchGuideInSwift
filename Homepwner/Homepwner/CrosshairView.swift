// Gold challenge: Add a cross hair view in the middle of the image capture area.
import UIKit

class CrosshairView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()

        // Vertical
        path.moveToPoint(CGPointMake(center.x, center.y - 20))
        path.addLineToPoint(CGPointMake(center.x, center.y + 20))

        // Horizontal
        path.moveToPoint(CGPointMake(center.x - 20, center.y))
        path.addLineToPoint(CGPointMake(center.x + 20, center.y))

        UIColor.blueColor().setStroke()
        path.stroke()
    }
}
