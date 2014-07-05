//
//  Item.swift
//  Homepwner
//
//  Created by Akshay Hegde on 7/4/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit
import CoreData

@objc(Item)  // Needed for compatibility with Objective-C
class Item: NSManagedObject {
    @NSManaged var itemName: String
    @NSManaged var serialNumber: String
    @NSManaged var valueInDollars: Double
    @NSManaged var dateCreated: NSDate
    @NSManaged var itemKey: String?
    @NSManaged var thumbnail: UIImage?
    @NSManaged var orderingValue: Double
    @NSManaged var assetType: NSManagedObject

    func setThumbnailFromImage(image: UIImage!) {
        let origImageSize = image.size
        let newRect = CGRectMake(0, 0, 40, 40)
        // Figure out a scaling ratio to make sure we maintain the same aspect ratio
        let ratio = max(newRect.size.width / origImageSize.width,
            newRect.size.height / origImageSize.height)

        // Create a transparent bitmap context with a scaling factor equal to that of the screen
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)

        // Create a path that is a rounded rectangle
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        // Make all subsequent drawing clip to this rounded rectangle
        path.addClip()

        // Center the image in the thumbnail
        var projectRect = CGRect()
        projectRect.size = CGSize(width: ratio * origImageSize.width, height: ratio * origImageSize.height)
        projectRect.origin = CGPoint(x: newRect.size.width / 20, y: projectRect.size.width / 2.0)

        // Draw the image on it
        image.drawInRect(projectRect)

        // Get the image from the image context; keep it as our thumbnail
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage

        // Cleanup image context resources; we're done
        UIGraphicsEndImageContext()
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()

        dateCreated = NSDate()

        let uuid = NSUUID()
        itemKey = uuid.UUIDString
    }
}