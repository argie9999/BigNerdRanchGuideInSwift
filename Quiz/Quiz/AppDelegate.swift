import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        var controller: QuizViewController? = QuizViewController()
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()

        return true
    }
}
