import UIKit

class HypnosisViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = "Hypnotize"
        tabBarItem.image = UIImage(named: "Hypno.png")
    }

    override func loadView() {
        view = HypnosisView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("HypnosisViewController loaded!")
    }
}
