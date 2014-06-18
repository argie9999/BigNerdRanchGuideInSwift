import UIKit

class ReminderViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem.title = "Reminder"
        tabBarItem.image = UIImage(named: "Time.png")
    }

    @IBAction func addReminder(sender: AnyObject) {
        let date = datePicker.date
        NSLog("Setting a reminder for %@", date)
    }
}
