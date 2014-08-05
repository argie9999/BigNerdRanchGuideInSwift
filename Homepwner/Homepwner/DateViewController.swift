import UIKit

class DateViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker?
    let item: Item

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)

        // Report DateViewController's restoration identifier for state restoration
        restorationIdentifier = NSStringFromClass(classForCoder)
        restorationClass = classForCoder
    }

    convenience required init(coder aDecoder: NSCoder!) {
        self.init(coder: aDecoder)
    }

    // Restrict Item created date. It must be created some time in the past.
    override func viewWillAppear(animated: Bool) {
        // Don't care about the time. Just set the date.
        datePicker!.datePickerMode = .Date
        datePicker!.maximumDate = NSDate(timeIntervalSinceNow: 60)
    }

    @IBAction func confirmDateChange(sender: UIButton) {
        item.dateCreated = datePicker!.date
        navigationController.popViewControllerAnimated(true)
    }
}