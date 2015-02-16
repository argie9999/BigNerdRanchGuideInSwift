import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        let hvc = HypnosisViewController()
        let rvc = ReminderViewController()

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [hvc, rvc]
        self.window!.rootViewController = tabBarController

        // Allow application to send local notifications
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))

        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()

        return true
    }
}