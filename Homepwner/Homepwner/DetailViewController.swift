import UIKit

let DateFormatter: NSDateFormatter? = nil
class DetailViewController: UIViewController, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate,
    UIViewControllerRestoration
{
    // MARK: Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem?
    @IBOutlet weak var changeDateButton: UIButton?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var serialNumberField: UITextField?
    @IBOutlet weak var serialNumberLabel: UILabel?
    @IBOutlet weak var toolbar: UIToolbar?
    @IBOutlet weak var trashItem: UIBarButtonItem?
    @IBOutlet weak var valueField: UITextField?
    @IBOutlet weak var valueLabel: UILabel?
    @IBOutlet weak var assetTypeButton: UIBarButtonItem?

    // MARK: Stored properties
    var item: Item?
    var dismissBlock: (() -> ())?
    var dateFormatter = DateFormatter
    var imagePickerPopover: UIPopoverController?
    var assetPickerPopover: UIPopoverController?

    init(item: Item) {
        NSException(name: "Wrong initializer", reason: "Use init(isNew:)", userInfo: nil).raise()
        super.init(nibName: nil, bundle: nil)
    }

    init(isNew: Bool) {
        super.init(nibName: nil, bundle: nil)

        // Report DetailViewController's restoration identifier for state restoration
        restorationIdentifier = NSStringFromClass(classForCoder)
        restorationClass = classForCoder

        if isNew {
            let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save:")
            navigationItem.rightBarButtonItem = doneItem

            let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
            navigationItem.leftBarButtonItem = cancelItem
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFonts",
            name: UIContentSizeCategoryDidChangeNotification, object: nil)

        // Observer to watch for settings changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingsChanged:",
            name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    required convenience init(coder aDecoder: NSCoder!) {
        self.init(isNew: false)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // Support dynamic type
    func updateFonts() {
        println("Updating fonts for dynamic type")
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

        // Update the labels and text fields to use dynamic fonts
        (nameLabel!.font, serialNumberLabel!.font, valueLabel!.font, dateLabel!.font) = (font, font, font, font)
        (nameField!.font, serialNumberField!.font, valueField!.font) = (font, font, font)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        prepareViewsForOrientation(interfaceOrientation)

        if item != nil {
            nameField!.text = item!.itemName
            serialNumberField!.text = item!.serialNumber
            valueField!.text = String(item!.valueInDollars)

            if dateFormatter == nil {
                dateFormatter = NSDateFormatter()
                dateFormatter!.dateStyle = .MediumStyle
                dateFormatter!.timeStyle = .NoStyle
            }
            self.dateLabel!.text = dateFormatter?.stringFromDate(item!.dateCreated)

            if let imageKey = item!.itemKey {
                let image = ImageStore.sharedStore.imageForKey(imageKey)
                if let imageToDisplay = image {
                    imageView!.image = imageToDisplay
                    trashItem!.enabled = true
                }
            }
            var typeLabel: String
            var labelText: AnyObject? = item!.assetType?.valueForKey("label")
            if labelText != nil {
                typeLabel = labelText as String
            }
            else {
                typeLabel = "None"
            }
            assetTypeButton!.title = NSLocalizedString("Type: \(typeLabel)", comment: "Asset type button")
        }
        updateFonts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgView = UIImageView(image: nil)
        imgView.contentMode = .ScaleAspectFit
        // Do not produce a translated constraint for this view
        imgView.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(imgView)
        imageView? = imgView

        // Set the vertical priorities to be less than those of the other subviews
        imageView?.setContentHuggingPriority(200, forAxis: .Vertical)
        imageView?.setContentCompressionResistancePriority(200, forAxis: .Vertical)

        let nameMap: [NSString: AnyObject] = [
            "imageView": imageView!,
            "changeDateButton": changeDateButton!,
            "toolbar": toolbar!
        ]

        // MARK: Constraints
        // ImageView is 0 points from the left and right edges
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|",
            options: nil,
            metrics: nil,
            views: nameMap)

        // ImageView is 8 pooints from the date label and the toolbar.
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[changeDateButton]-[imageView]-[toolbar]",
            options: nil,
            metrics: nil,
            views: nameMap)

        // Add constrains to view
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)

        if (item != nil) {
            // Save changes to Item
            item!.itemName = nameField!.text
            item!.serialNumber = serialNumberField!.text

            if let value = valueField!.text.toInt() {
                // Is it changed from the default?
                if CInt(value) != item!.valueInDollars {
                    item!.valueInDollars = CInt(value)

                    // Store it as the default for the next time.
                    NSUserDefaults.standardUserDefaults().setInteger(value,
                        forKey: NEXT_ITEM_VALUE_PREFS_KEY)
                }
            }
        }
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if let image = editedImage {
            if let imageKey = item!.itemKey {
                item!.setThumbnailFromImage(image)
                ImageStore.sharedStore.setImage(image, forKey: imageKey)
                imageView!.image = image
                if (imagePickerPopover != nil) {
                    imagePickerPopover!.dismissPopoverAnimated(true)
                    imagePickerPopover = nil
                }
                else {
                    dismissViewControllerAnimated(true) { println("Closing image picker") }
                }
            }
        }
        // Enable the trash toolbar item
        trashItem!.enabled = true
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Mark: UIPopoverControllerDelegate
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        println("User dismissed popover")
        if (imagePickerPopover != nil) {
            imagePickerPopover = nil
        }
        if (assetPickerPopover != nil) {
            assetPickerPopover = nil
        }
    }

    // MARK: Orientation related methods
    /**
    Disables the camera button for the iPhone in Landscape.
    */
    func prepareViewsForOrientation(orientation: UIInterfaceOrientation) {
        // Is it an iPad? No preparation necessary
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return
        }

        // Is it landscape?
        if orientation.isLandscape {
            imageView!.hidden = true
            cameraButton!.enabled = false
        }
        else {
            imageView!.hidden = false
            cameraButton!.enabled = true
        }
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,
        duration: NSTimeInterval)
    {
        prepareViewsForOrientation(toInterfaceOrientation)
    }

    // MARK: IBActions
    @IBAction func changeDate(sender: UIButton) {
        let dateViewController = DateViewController(item: item!)
        navigationController.pushViewController(dateViewController, animated: true)
    }

    @IBAction func takePicture(sender: UIBarButtonItem) {

        // If the popover is already up, get rid of it
        if (imagePickerPopover != nil) {
            if imagePickerPopover!.popoverVisible {
                imagePickerPopover!.dismissPopoverAnimated(true)
                imagePickerPopover = nil
                return
            }
        }

        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera

            // Gold challenge: Add a cross hair view in the middle of the image capture area.
            imagePicker.cameraOverlayView = CrosshairView(frame: view.bounds)
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        // Place image picker on the screen

        // Check for iPad device before instantiating the popover controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            println("Detected iPad, showing image picker in popover controller.")
            imagePickerPopover = UIPopoverController(contentViewController: imagePicker)
            imagePickerPopover!.delegate = self

            // Use a dark popover background
            imagePickerPopover!.popoverBackgroundViewClass = DarkPopoverBackgroundView.classForCoder()
            imagePickerPopover!.presentPopoverFromBarButtonItem(sender,
                permittedArrowDirections: .Any,
                animated: true)
        }
        else {
            presentViewController(imagePicker, animated: true) { println("Not an iPad, showing Image Picker") }
        }
    }

    // Silver challenge: Allow a user to remove an item's image.
    @IBAction func removePicture(sender: UIBarButtonItem) {
        if (imageView!.image != nil) {
            println("Alert dialog shown")
            // Show an alert dialog before deleting an image.
            var alert = UIAlertController(title: "Remove Image?", message: "",
                preferredStyle: .Alert)
            // Add a destructive delete button.
            // When the user clicks on Delete, the closure is invoked and removes the image.
            alert.addAction(UIAlertAction(title: "Delete", style: .Destructive) { (_: UIAlertAction!) in
                println("Removing picture")
                ImageStore.sharedStore.deleteImageForKey(self.item!.itemKey!)
                self.item!.itemKey = nil
                self.item!.thumbnail = nil
                self.imageView!.image = nil
                self.trashItem!.enabled = false
                })

            // When user presses cancel, don't do anything.
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { (_: UIAlertAction!) in
                println("User selected not to remove image.")
                })
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    // Silver challenge: dismiss the keyboard when user touches the background
    @IBAction func backgroundTapped(sender: UIControl) {
        view.endEditing(true)
    }

    @IBAction func showAssetTypePicker(sender: UIBarButtonItem) {
        view.endEditing(true)
        let avc = AssetTypeViewController()
        avc.item = item

        // Bronze challenge; present the AssetTypeViewController in
        // a PopoverController if the device is an iPad
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            assetPickerPopover = UIPopoverController(contentViewController: avc)
            assetPickerPopover!.delegate = self
            avc.dismissBlock = {
                self.assetPickerPopover!.dismissPopoverAnimated(true)
                self.assetPickerPopover = nil
                var typeLabel: String
                var labelText: AnyObject? = self.item!.assetType?.valueForKey("label")
                if labelText != nil {
                    typeLabel = labelText as String
                }
                else {
                    typeLabel = "None"
                }
                self.assetTypeButton!.title = "Type: \(typeLabel)"
            }
            assetPickerPopover!.presentPopoverFromBarButtonItem(sender,
                permittedArrowDirections: .Any,
                animated: true)
        }
        else {
            navigationController.pushViewController(avc, animated: true)
        }
    }

    // MARK: selectors

    func save(sender: AnyObject) {
        presentingViewController.dismissViewControllerAnimated(true, completion: dismissBlock)
    }

    func cancel(sender: AnyObject) {
        if item != nil {
            ItemStore.sharedStore.removeItem(item!)
            presentingViewController.dismissViewControllerAnimated(true) {
                println("Cancelling new item creation and asking to dismiss DetailViewController.")
            }
        }
    }

    func settingsChanged(note: NSNotification!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let newItemName = defaults.objectForKey(NEXT_ITEM_NAME_PREFS_KEY) as String

        NSUserDefaults.standardUserDefaults().setObject(newItemName,
            forKey: NEXT_ITEM_NAME_PREFS_KEY)
    }

    // MARK: UIViewControllerRestoration methods
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject]!,
        coder: NSCoder!) -> UIViewController!
    {
        // If creating a new item, path array's count will be 3, otherwise 2.
        let isNew = identifierComponents.count == 3 ? true : false

        return DetailViewController(isNew: isNew)
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder!) {
        if item != nil {
            println("Encoding item information for restoration later")
            coder.encodeObject(item!.itemKey, forKey: "item.itemKey")

            // Save changes into item
            self.item!.itemName = nameField!.text
            self.item!.serialNumber = serialNumberField!.text
            if let value = valueField!.text.toInt() {
                self.item!.valueInDollars = CInt(value)
            }

            // Have store save changes to disk
            ItemStore.sharedStore.saveChanges()
        }

        super.encodeRestorableStateWithCoder(coder)
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!) {
        let itemKey = coder.decodeObjectForKey("item.itemKey") as? String
        let allItems = ItemStore.sharedStore.allItems

        for item in allItems {
            if itemKey != nil {
                if (item.itemKey != nil) {
                    if itemKey == item.itemKey! {
                        self.item = item
                        break;
                    }
                }
            }
        }

        super.decodeRestorableStateWithCoder(coder)
    }
}
