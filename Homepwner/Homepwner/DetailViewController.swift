import UIKit

let DateFormatter: NSDateFormatter? = nil
class DetailViewController: UIViewController, UINavigationControllerDelegate,
     UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate
{
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField
    @IBOutlet weak var serialNumberField: UITextField
    @IBOutlet weak var valueField: UITextField
    @IBOutlet weak var dateLabel: UILabel
    @IBOutlet weak var changeDateButton: UIButton
    @IBOutlet weak var imageView: UIImageView
    @IBOutlet weak var trashItem: UIBarButtonItem
    @IBOutlet weak var cameraButton: UIBarButtonItem
    @IBOutlet weak var toolbar: UIToolbar

    // MARK: Stored properties
    var item: Item?
    var dismissBlock: (() -> ())?
    var dateFormatter = DateFormatter
    var imagePickerPopover: UIPopoverController?

    init(item: Item) {
        NSException(name: "Wrong initializer", reason: "Use init(isNew:)", userInfo: nil)
        super.init(nibName: nil, bundle: nil)
    }

    init(isNew: Bool) {
        super.init(nibName: nil, bundle: nil)

        if isNew {
            let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save:")
            navigationItem.rightBarButtonItem = doneItem

            let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
            navigationItem.leftBarButtonItem = cancelItem
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        prepareViewsForOrientation(interfaceOrientation)

        if item {
            nameField.text = item!.itemName
            serialNumberField.text = item!.serialNumber
            valueField.text = String(item!.valueInDollars)

            if !dateFormatter {
                dateFormatter = NSDateFormatter()
                dateFormatter!.dateStyle = .MediumStyle
                dateFormatter!.timeStyle = .NoStyle
            }
            self.dateLabel.text = dateFormatter?.stringFromDate(item!.dateCreated)

            if let imageKey = item!.itemKey {
                let image = ImageStore.sharedStore.imageForKey(imageKey)
                if let imageToDisplay = image {
                    imageView.image = imageToDisplay
                    trashItem.enabled = true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgView = UIImageView(image: nil)
        imgView.contentMode = .ScaleAspectFit
        // Do not produce a translated constraint for this view
        imgView.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(imgView)
        imageView = imgView

        // Set the vertical priorities to be less than those of the other subviews
        imageView.setContentHuggingPriority(200, forAxis: .Vertical)
        imageView.setContentCompressionResistancePriority(200, forAxis: .Vertical)

        let nameMap = [
            "imageView": imageView,
            "changeDateButton": changeDateButton,
            "toolbar": toolbar
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

        if item {
            // Save changes to Item
            item!.itemName = nameField.text
            item!.serialNumber = serialNumberField.text
            if let value = valueField.text.toInt() {
                item!.valueInDollars = value
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
                imageView.image = image
                if imagePickerPopover {
                    imagePickerPopover!.dismissPopoverAnimated(true)
                    imagePickerPopover = nil
                }
                else {
                    dismissViewControllerAnimated(true) { println("Closing image picker") }
                }
            }
        }
        // Enable the trash toolbar item
        trashItem.enabled = true
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // Mark: UIPopoverControllerDelegate
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        println("User dismissed popover")
        imagePickerPopover = nil
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
            imageView.hidden = true
            cameraButton.enabled = false
        }
        else {
            imageView.hidden = false
            cameraButton.enabled = true
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
        if imagePickerPopover {
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
        if imageView.image {
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
                self.imageView.image = nil
                self.trashItem.enabled = false
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


    // MARK: selectors

    func save(sender: AnyObject) {
        presentingViewController.dismissViewControllerAnimated(true, completion: dismissBlock)
    }

    func cancel(sender: AnyObject) {
        if item {
            ItemStore.sharedStore.removeItem(item!)
            presentingViewController.dismissViewControllerAnimated(true) {
                println("Cancelling new item creation and asking to dismiss DetailViewController.")
            }
        }
    }
}
