//
//  Item.swift
//  Homepwner
//
//  Created by Akshay Hegde on 7/7/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit
import CoreData

class Item: NSManagedObject {

    // MARK: Stored properties
    @NSManaged var dateCreated: NSDate
    @NSManaged var itemKey: String
    @NSManaged var itemName: String
    @NSManaged var orderingValue: Double
    @NSManaged var serialNumber: String
    @NSManaged var thumbnail: UIImage?
    @NSManaged var valueInDollars: Int32
    @NSManaged var assetType: NSManagedObject

    func setThumbnailFromImage(image: UIImage) {
        let origImageSize = image.size
        let newRect = CGRectMake(0, 0, 40, 40)
        let ratio = max(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height)
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0)

        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 5.0)
        path.addClip()

        var projectRect = CGRect()
        projectRect.size = CGSizeMake(ratio * origImageSize.width, ratio * origImageSize.height)
        projectRect.origin = CGPointMake((newRect.size.width - projectRect.size.width) / 2.0,
            (newRect.size.height - projectRect.size.height) / 2.0)

        image.drawInRect(projectRect)
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        thumbnail = smallImage

        UIGraphicsEndImageContext()
    }

    // MARK: Overriden function
    override func awakeFromInsert() {
        super.awakeFromInsert()

        dateCreated = NSDate()

        let uuid = NSUUID()
        itemKey = uuid.UUIDString
    }
}
