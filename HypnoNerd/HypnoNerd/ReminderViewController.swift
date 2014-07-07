import UIKit

// Extend UILocalNotification for fun.
extension UILocalNotification {
    convenience init(alert: String, withDate date: NSDate) {
        self.init()
        alertBody = alert
        fireDate = date
    }
}

class ReminderViewController: UIViewController, UIViewControllerRestoration {

    @IBOutlet weak var datePicker: UIDatePicker

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = "Reminder"
        tabBarItem.image = UIImage(named: "Time.png")

        // Report ReminderViewController's restoration id
        restorationIdentifier = NSStringFromClass(classForCoder)
        restorationClass = classForCoder
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("ReminderViewController loaded!")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        datePicker.minimumDate = NSDate(timeIntervalSinceNow: 60)
    }

    @IBAction func addReminder(sender: AnyObject) {
        let date = datePicker.date
        // Use that cool extension.
        println("Setting a reminder for %@", date)
        // Using the cool extension to UILocalNotification defined above.
        let note = UILocalNotification(alert: "Hypnotize me!", withDate: date)
        UIApplication.sharedApplication().scheduleLocalNotification(note)
    }

    // MARK: UIViewControllerRestoration protocol methods
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: AnyObject[]!,
        coder: NSCoder!) -> UIViewController!
    {
        return ReminderViewController()
    }
}
