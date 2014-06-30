import UIKit

class ImageStore: NSObject {
    class var sharedStore: ImageStore {
        return SharedStore
    }

    var dictionary = Dictionary<NSString, UIImage>()
    
    init() {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }
}

let SharedStore = ImageStore()