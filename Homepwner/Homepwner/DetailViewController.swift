import UIKit

let _dateFormatter: NSDateFormatter? = nil
class DetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField
    @IBOutlet weak var serialNumberField: UITextField
    @IBOutlet weak var valueField: UITextField
    @IBOutlet weak var dateLabel: UILabel

    // MARK: Stored properties
    strong let item: Item
    var dateFormatter = _dateFormatter

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    override func viewWillAppear(animated: Bool) {
        nameField.text = item.itemName
        serialNumberField.text = item.serialNumber
        valueField.text = String(item.valueInDollars)

        if !dateFormatter {
            dateFormatter = NSDateFormatter()
            dateFormatter!.dateStyle = .MediumStyle
            dateFormatter!.timeStyle = .NoStyle
        }
        self.dateLabel.text = dateFormatter?.stringFromDate(item.dateCreated)
    }
}
