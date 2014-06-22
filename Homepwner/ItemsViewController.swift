import UIKit

class ItemsViewController: UITableViewController {
    // Since we can't have a strong optional type, this is a workaround.
    // Could be better?
    var _headerView: UIView? = nil
    @IBOutlet strong var headerView: UIView {
    get {
        if !_headerView {
            NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        }
        return _headerView!
    }
    set {
        _headerView = newValue
    }
    }
    
    convenience init() {
        self.init(style: .Plain)
        for _ in 0..5 {
            ItemStore.sharedStore.createItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.tableHeaderView = headerView
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let items = ItemStore.sharedStore.allItems
        cell.textLabel.text = items[indexPath.row].description()
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        if let button = sender as? UIButton {
            // In objective-c this is self.isEditing
            if editing {
                button.setTitle("Edit", forState: .Normal)
                setEditing(false, animated: true)
            }
            else {
                button.setTitle("Done", forState: .Normal)
                setEditing(true, animated: true)
            }
        }
    }
}