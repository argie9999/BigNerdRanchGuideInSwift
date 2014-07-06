//
//  Item.m
//  Homepwner
//
//  Created by Akshay Hegde on 7/5/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic dateCreated;
@dynamic itemKey;
@dynamic itemName;
@dynamic orderingValue;
@dynamic serialNumber;
@dynamic thumbnail;
@dynamic valueInDollars;
@dynamic assetType;

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    CGRect newRect = CGRectMake(0, 0, 40, 0);
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);

    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];

    [path addClip];
    CGRect projectRect;
    projectRect.size = CGSizeMake(ratio * origImageSize.width, ratio * origImageSize.height);
    projectRect.origin = CGPointMake((newRect.size.width - projectRect.size.width) / 2.0,
                                     (newRect.size.height - projectRect.size.height) / 2.0);

    [image drawInRect:projectRect];

    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;

    UIGraphicsEndImageContext();
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.dateCreated = [NSDate date];

    NSUUID *uuid = [[NSUUID alloc] init];
    self.itemKey = [uuid UUIDString];
}

@end