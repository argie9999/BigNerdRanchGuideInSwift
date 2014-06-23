import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField
    @IBOutlet weak var serialNumberField: UITextField
    @IBOutlet weak var valueField: UITextField
    @IBOutlet weak var dateLabel: UILabel

    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
