import UIKit

class HypnosisViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = "Hypnotize"
        tabBarItem.image = UIImage(named: "Hypno.png")
    }

    override func loadView() {
        let backgroundView = HypnosisView(frame: UIScreen.mainScreen().bounds)
        let textField = UITextField(frame: CGRectMake(40, 70, 240, 30))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        backgroundView.addSubview(textField)

        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("HypnosisViewController loaded!")
    }
}
