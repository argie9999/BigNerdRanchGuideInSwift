import UIKit

class ImageStore: NSObject {
    var dictionary = Dictionary<NSString, UIImage>()

    class var sharedStore: ImageStore {
        return SharedStore
    }

    init() {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }
}

let SharedStore = ImageStore()