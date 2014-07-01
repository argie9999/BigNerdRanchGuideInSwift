import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        let ivc = ItemsViewController()
        let navController = UINavigationController(rootViewController: ivc)
        self.window!.rootViewController = navController
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()

        return true
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        let success = ItemStore.sharedStore.saveChanges()

        if success {
            println("Saved all of the Items")
        }
        else {
            println("Could not save any of the Items.")
        }
    }
}