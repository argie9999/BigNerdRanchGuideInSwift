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
        let nc = NSNotificationCenter.defaultCenter()
        super.init()

        nc.addObserver(self, selector: "clearCache:",
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: nil)
    }

    func setImage(image: UIImage, forKey key: String) {
        dictionary[key] = image
        let imagePath = imagePathForKey(key)
        let data = UIImageJPEGRepresentation(image, 0.5)

        println("Writing image to \(imagePath)")
        data.writeToFile(imagePath, atomically: true)
    }

    func deleteImageForKey(key: String) {
        dictionary.removeValueForKey(key)

        let imagePath = imagePathForKey(key)
        NSFileManager.defaultManager().removeItemAtPath(imagePath, error: nil)
    }

    func imageForKey(key: String) -> UIImage? {
        var result = dictionary[key]

        // If we don't have the image, try to retrieve it from the filesystem
        if !result {
            let imagePath = imagePathForKey(key)
            result = UIImage(contentsOfFile: imagePath)

            if result {
                println("Found image at \(imagePath)")
                dictionary[key] = result
            }
            else {
                println("Unable to find \(imagePathForKey(key)) at \(imagePath)")
            }
        }

        return result
    }

    // MARK: Archive related methods
    func imagePathForKey(key: String) -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        return documentPath.stringByAppendingPathComponent(key)
    }

    func clearCache(note: NSNotification) {
        println("Flushing \(dictionary.count) images out of the cache.")
        dictionary.removeAll(keepCapacity: false)
    }
}