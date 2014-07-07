import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(application: UIApplication, willFinishLaunchingWithOptions
        launchOptions: NSDictionary?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()

        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: NSDictionary?) -> Bool
    {
        // If state restoration did not occur, set up the view controller heirarchy
        if !window!.rootViewController {
            let hvc = HypnosisViewController()
            let rvc = ReminderViewController()

            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [hvc, rvc]
            self.window!.rootViewController = tabBarController

            // Allow application to send local notifications
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))

        }
        self.window!.makeKeyAndVisible()

        return true
    }

    func application(application: UIApplication!,
        shouldSaveApplicationState coder: NSCoder!) -> Bool
    {
        return true
    }

    func application(application: UIApplication!,
        shouldRestoreApplicationState coder: NSCoder!) -> Bool
    {
        return true
    }

    func application(application: UIApplication!,
        viewControllerWithRestorationIdentifierPath identifierComponents: AnyObject[]!,
        coder: NSCoder!) -> UIViewController!
    {
        // Create a new UITabBarController
        let tc = UITabBarController()

        // The last object in the path array is the restoration identifier for this view controller
        tc.restorationIdentifier = identifierComponents[identifierComponents.count - 1] as String

        // If there is only one identifier component, then this is the root view controller 
        if identifierComponents.count == 1 {
            window!.rootViewController = tc
        }

        return tc
    }
}
