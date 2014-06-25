import UIKit

let _sharedStore = ImageStore()
class ImageStore: NSObject {
    class var sharedStore: ImageStore { return _sharedStore }
    var dictionary = Dictionary<NSString, UIImage>()

    init() {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }
}