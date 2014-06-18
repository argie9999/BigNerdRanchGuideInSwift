import UIKit

class HypnosisViewController: UIViewController {
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem.title = "Hypnotize"
        tabBarItem.image = UIImage(named: "Hypno@2x.png")
    }

    override func loadView() {
        view = HypnosisView()
    }

}
