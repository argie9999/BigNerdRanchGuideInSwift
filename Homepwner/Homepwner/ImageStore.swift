import UIKit

let _sharedStore = ImageStore()
class ImageStore: NSObject {
    class var sharedStore: ImageStore { return _sharedStore }
    var dictionary = Dictionary<String, UIImage>()

    init() {
        NSException(name: "Singleton", reason: "Use ItemStore.sharedStore", userInfo: nil)
    }

    func setImage(image: UIImage, forKey key: String) {
        dictionary[key] = image
    }

    func imageFor(key: String) -> UIImage? {
        return dictionary[key]
    }

    func deleteImageFor(key: String) {
        dictionary.removeValueForKey(key)
    }
}