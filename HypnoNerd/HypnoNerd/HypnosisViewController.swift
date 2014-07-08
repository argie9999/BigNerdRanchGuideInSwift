import UIKit

// extensions are fun
extension UILabel {
    convenience init(backgroundColor: UIColor, text: String) {
        self.init()
        self.backgroundColor = backgroundColor
        self.text = text
    }
}

class HypnosisViewController: UIViewController, UITextFieldDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = "Hypnotize"
        tabBarItem.image = UIImage(named: "Hypno.png")
    }

    override func loadView() {
        let backgroundView = HypnosisView(frame: UIScreen.mainScreen().bounds)
        let textField = UITextField(frame: CGRectMake(40, 70, 240, 30))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Hypnotize me"
        textField.returnKeyType = UIReturnKeyType.Done
        textField.delegate = self
        backgroundView.addSubview(textField)

        view = backgroundView
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        drawHypnoticMessage(textField.text)
        textField.text = ""
        textField.resignFirstResponder()

        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("HypnosisViewController loaded!")
    }

    func drawHypnoticMessage(message: String) {
        for _ in 0..<20 {
            // use the cool extension to UILabel defined above.
            let messageLabel = UILabel(backgroundColor: UIColor.clearColor(), text: message)
            messageLabel.sizeToFit()

            // Get random x value inside HynosisView
            let width = UInt32(view.bounds.size.width - messageLabel.bounds.size.width)
            let x = arc4random() % width

            // Get random y value inside HypnosisView
            let height = UInt32(view.bounds.size.height - messageLabel.bounds.size.height)
            let y = arc4random() % height

            var frame = messageLabel.frame
            frame.origin = CGPointMake(CGFloat(x), CGFloat(y))
            messageLabel.frame = frame

            view.addSubview(messageLabel)

            // Set the labels initial alpha
            messageLabel.alpha = 0.0

            // Animate the alpha to 1.0
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: {
                messageLabel.alpha = 1.0
                }, completion: nil)

            // Animate the center of the labels first to the middle of the screen and then
            // to a random position on the screen
            UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: nil, animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.8) {
                    messageLabel.center = self.view.center
                }

                UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2) {
                    let x = UInt32(arc4random()) % UInt32(width)
                    let y = UInt32(arc4random()) % UInt32(height)
                    messageLabel.center = CGPointMake(CGFloat(x), CGFloat(y))
                }
                }) { Bool -> Void in println("Animation finished") }

            // Add parallax effect along the horizontal axis
            var motionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(motionEffect)

            // Along the vertical axis now
            motionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            messageLabel.addMotionEffect(motionEffect)
        }
    }
}
