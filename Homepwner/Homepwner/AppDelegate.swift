import UIKit

let NEXT_ITEM_VALUE_PREFS_KEY = "NextItemValue"
let NEXT_ITEM_NAME_PREFS_KEY = "NextItemName"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let factorySettings = [
            NEXT_ITEM_VALUE_PREFS_KEY: 75,
            NEXT_ITEM_NAME_PREFS_KEY: "Coffee Cup",
        ]

        defaults.registerDefaults(factorySettings)
    }

    func application(application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()

        return true
    }

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        // If state restoration did not occur, set up the view controller hierarchy
        if window?.rootViewController == nil {
            let ivc = ItemsViewController()
            let navController = UINavigationController(rootViewController: ivc)

            // Give the navigation controller a restoration identifier
            navController.restorationIdentifier = NSStringFromClass(navController.classForCoder)
            window!.rootViewController = navController
        }
        window!.makeKeyAndVisible()

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
        viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject]!,
        coder: NSCoder!) -> UIViewController!
    {
        // Create a new navigation controller
        let nvc = UINavigationController()

        // The last object in the path array is the restoration identifier for this view controller
        nvc.restorationIdentifier = identifierComponents.last as String

        // If there is only 1 identifier component, then this is the root view controller 
        if identifierComponents.count == 1 {
            window!.rootViewController = nvc
        }

        return nvc
    }
}
