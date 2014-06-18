import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: NSDictionary?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        let hvc = HypnosisViewController(nibName: nil, bundle: nil)
        let appBundle = NSBundle.mainBundle()
        let rvc = ReminderViewController(nibName: "ReminderViewController",
                                          bundle: appBundle)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [hvc, rvc]
        self.window!.rootViewController = tabBarController
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        return true
    }
}