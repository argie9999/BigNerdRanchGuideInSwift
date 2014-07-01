import UIKit

class ImageStore: NSObject {
    var dictionary = Dictionary<NSString, UIImage>()

    // Thread-safe read-only instance.
    class var sharedStore: ImageStore {
        struct Static {
            static let instance: ImageStore = ImageStore()
        }
        return Static.instance
    }

    init() {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }
}