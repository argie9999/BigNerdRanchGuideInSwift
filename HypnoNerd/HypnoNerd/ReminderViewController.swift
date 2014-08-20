import UIKit

// Extend UILocalNotification for fun.
extension UILocalNotification {
    convenience init(alert: String, withDate date: NSDate) {
        self.init()
        alertBody = alert
        fireDate = date
    }
}

public class ReminderViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker?

    override init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = "Reminder"
        tabBarItem.image = UIImage(named: "Time.png")
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        println("ReminderViewController loaded!")
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        datePicker?.minimumDate = NSDate(timeIntervalSinceNow: 60)
    }

    @IBAction public func addReminder(sender: AnyObject) {
        let date = datePicker!.date
        // Use that cool extension.
        println("Setting a reminder for %@", date)
        // Using the cool extension to UILocalNotification defined above.
        let note = UILocalNotification(alert: "Hypnotize me!", withDate: date)
        UIApplication.sharedApplication().scheduleLocalNotification(note)
    }
}
