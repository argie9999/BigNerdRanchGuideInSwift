import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        var controller: QuizViewController? = QuizViewController()
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()

        return true
    }
}
