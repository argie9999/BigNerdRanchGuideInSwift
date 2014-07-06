//
//  Item.h
//  Homepwner
//
//  Created by Akshay Hegde on 7/5/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Item: NSManagedObject

@property (nonatomic) NSDate * dateCreated;
@property (nonatomic) NSString * itemKey;
@property (nonatomic) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic) NSString * serialNumber;
@property (nonatomic) UIImage * thumbnail;
@property (nonatomic) int valueInDollars;
@property (nonatomic) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end