import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        let ivc = ItemsViewController(nibName: nil, bundle: nil)
        self.window!.rootViewController = ivc
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()

        return true
    }
}