//
//  AssetTypeViewController.swift
//  Homepwner
//
//  Created by Akshay Hegde on 7/5/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit
import CoreData

class AssetTypeViewController: UITableViewController, UIPopoverControllerDelegate {

    var item: Item?
    var dismissBlock: (() -> ())?

    override init() {
        super.init(style: .Plain)
        self.navigationItem.title = NSLocalizedString("Asset Type", comment: "AssetTypeViewController title")
    }

     convenience required init(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allAssetTypes().count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell",
            forIndexPath: indexPath) as UITableViewCell

        let allAssets = ItemStore.sharedStore.allAssetTypes()
        let assetType = allAssets[indexPath.row] as NSManagedObject

        let assetLabel = assetType.valueForKey("label") as String
        cell.textLabel.text = assetLabel

        if item != nil {
            // Checkmark the one that is currently selected
            if assetType == item!.assetType? {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        cell.accessoryType = .Checkmark

        let allAssets = ItemStore.sharedStore.allAssetTypes()
        let assetType = allAssets[indexPath.row] as NSManagedObject
        item!.assetType = assetType
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            navigationController.popViewControllerAnimated(true)
        }
        else {
            if dismissBlock != nil {
                dismissBlock!()
            }
        }
    }
}