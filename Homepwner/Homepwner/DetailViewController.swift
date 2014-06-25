import UIKit

let _dateFormatter: NSDateFormatter? = nil
class DetailViewController: UIViewController, UINavigationControllerDelegate,
     UIImagePickerControllerDelegate, UITextFieldDelegate
{
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField
    @IBOutlet weak var serialNumberField: UITextField
    @IBOutlet weak var valueField: UITextField
    @IBOutlet weak var dateLabel: UILabel
    @IBOutlet weak var imageView: UIImageView
    @IBOutlet weak var toolbar: UIToolbar

    // MARK: Stored properties
    let item: Item
    var dateFormatter = _dateFormatter

    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = item.itemName
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.itemName
        serialNumberField.text = item.serialNumber
        valueField.text = String(item.valueInDollars)

        if !dateFormatter {
            dateFormatter = NSDateFormatter()
            dateFormatter!.dateStyle = .MediumStyle
            dateFormatter!.timeStyle = .NoStyle
        }
        self.dateLabel.text = dateFormatter?.stringFromDate(item.dateCreated)

        let image = ImageStore.sharedStore.dictionary[item.itemKey]
        if let imageToDisplay  = image {
            imageView.image = imageToDisplay
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)

        // Save changes to Item
        item.itemName = nameField.text
        item.serialNumber = serialNumberField.text
        if let value = valueField.text.toInt() {
            item.valueInDollars = value
        }
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if let image = editedImage {
            ImageStore.sharedStore.dictionary[item.itemKey] = image
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
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
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    // Silver challenge
    @IBAction func backgroundTapped(sender: UIControl) {
        view.endEditing(true)
    }
}
