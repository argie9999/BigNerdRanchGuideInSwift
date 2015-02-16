//
//  PaletteViewController.swift
//  Colorboard
//
//  Created by Akshay Hegde on 7/8/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class PaletteViewController: UITableViewController {

    var colors = [ColorDescription]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return colors.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell",
            forIndexPath: indexPath) as! UITableViewCell

        let color = colors[indexPath.row]
        cell.textLabel?.text = color.name

        return cell
    }

    // MARK: Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "NewColor" {
            // If adding a new color, create an instance
            let color = ColorDescription()
            colors.append(color)

            // Then use the segue to set the color on the view controller
            let nc = segue.destinationViewController as? UINavigationController
            let mvc = nc?.topViewController as? ColorViewController
            mvc?.colorDescription = color
        }
        else if (segue.identifier == "ExistingColor") {
            // For the push segue, the sender is the UITableViewCell
            if let cell = sender as? UITableViewCell,
                ip = tableView.indexPathForCell(cell)
            {
                let color = colors[ip.row]
                // Set the color and tell the view that this is an existing color
                if let cvc = segue.destinationViewController as? ColorViewController {
                    cvc.colorDescription = color
                    cvc.existingColor = true
                }
            }
        }
    }
}