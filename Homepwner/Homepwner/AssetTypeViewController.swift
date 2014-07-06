//
//  AssetTypeViewController.swift
//  Homepwner
//
//  Created by Akshay Hegde on 7/5/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit
import CoreData

class AssetTypeViewController: UITableViewController {

    var item: Item?

    convenience init() {
        self.init(style: .Plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allAssetTypes.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell",
            forIndexPath: indexPath) as UITableViewCell

        let allAssets = ItemStore.sharedStore.allAssetTypes
        let assetType = allAssets[indexPath.row] as NSManagedObject

        let assetLabel = assetType.valueForKey("label") as String
        cell.textLabel.text = assetLabel

        // Checkmark the one that is currently selected
        if assetType == item!.assetType {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        cell.accessoryType = .Checkmark

        let allAssets = ItemStore.sharedStore.allAssetTypes
        let assetType = allAssets[indexPath.row] as NSManagedObject
        item!.assetType = assetType

        navigationController.popViewControllerAnimated(true)
    }
}