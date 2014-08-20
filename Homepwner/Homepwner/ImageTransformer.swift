//
//  ImageTransformer.swift
//  Homepwner
//
//  Created by Akshay Hegde on 7/4/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

@objc(ImageTransformer)
class ImageTransformer: NSValueTransformer {

    func transformedValueClass() -> AnyClass! {
        return NSData.classForCoder()
    }

    override func transformedValue(value: AnyObject!) -> AnyObject! {
        if value == nil {
            return nil
        }
        if let val = value as? NSData {
            return val
        }
        return UIImagePNGRepresentation(value as UIImage)
    }

    override func reverseTransformedValue(value: AnyObject!) -> AnyObject! {
        return UIImage(data: value as? NSData)
    }
}