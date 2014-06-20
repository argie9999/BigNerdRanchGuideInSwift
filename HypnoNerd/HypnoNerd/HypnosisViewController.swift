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
        NSLog("HypnosisViewController loaded!")
    }

    func drawHypnoticMessage(message: String) {
        for _ in 0..20 {
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
        }
    }
}