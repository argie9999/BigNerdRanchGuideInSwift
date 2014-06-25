import UIKit

let _dateFormatter: NSDateFormatter? = nil
class DetailViewController: UIViewController, UINavigationControllerDelegate,
     UIImagePickerControllerDelegate
{
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField
    @IBOutlet weak var serialNumberField: UITextField
    @IBOutlet weak var valueField: UITextField
    @IBOutlet weak var dateLabel: UILabel
    @IBOutlet weak var imageView: UIImageView
    @IBOutlet weak var toolbar: UIToolbar

    // MARK: Stored properties
    strong let item: Item
    var dateFormatter = _dateFormatter

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = item.itemName
    }

    override func viewWillAppear(animated: Bool) {
        nameField.text = item.itemName
        serialNumberField.text = item.serialNumber
        valueField.text = String(item.valueInDollars)

        if !dateFormatter {
            dateFormatter = NSDateFormatter()
            dateFormatter!.dateStyle = .MediumStyle
            dateFormatter!.timeStyle = .NoStyle
        }
        self.dateLabel.text = dateFormatter?.stringFromDate(item.dateCreated)
    }

    override func viewWillDisappear(animated: Bool) {
        // Clear first responder
        view.endEditing(true)

        // Save changes to Item
        item.itemName = nameField.text
        item.serialNumber = serialNumberField.text
        if let value = valueField.text.toInt() {
            item.valueInDollars = value
        }
    }

    // Silver challenge: When the background is touched when editing
    // the value field, dismiss the keyboard.
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        valueField.resignFirstResponder()
    }

    // MARK: Delegate methods
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = originalImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }


    // MARK: IBActions
    @IBAction func changeDate(sender: UIButton) {
        let dateViewController = DateViewController(item: item)
        navigationController.pushViewController(dateViewController, animated: true)
    }

    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}