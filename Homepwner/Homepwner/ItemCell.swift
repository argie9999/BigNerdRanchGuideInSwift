//
//  ItemCell.swift
//  Homepwner
//
//  Created by ajh17 on 7/1/14.
//  Copyright (c) 2014 Akshay Hegde. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView
    @IBOutlet weak var nameLabel: UILabel
    @IBOutlet weak var serialNumberLabel: UILabel
    @IBOutlet weak var valueLabel: UILabel
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint
    var actionBlock: (() -> ())?

    @IBAction func showImage(id: UIButton) {
        if actionBlock {
            actionBlock!()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func updateInterfaceForDynamicTypeSize() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

        (nameLabel.font, serialNumberLabel.font, valueLabel.font) = (font, font, font)

        struct Static {
            static let imageSizeDict: Dictionary<NSString, Int> = [
                UIContentSizeCategoryExtraSmall: 40,
                UIContentSizeCategorySmall: 40,
                UIContentSizeCategoryMedium: 40,
                UIContentSizeCategoryLarge: 40,
                UIContentSizeCategoryExtraLarge: 45,
                UIContentSizeCategoryExtraExtraLarge: 55,
                UIContentSizeCategoryExtraExtraExtraLarge: 65,
            ]
        }

        let userSize = UIApplication.sharedApplication().preferredContentSizeCategory
        let imageSize = Static.imageSizeDict[userSize]

        // Just to be safe.
        if let imgSize = imageSize {
            imageViewHeightConstraint.constant = CGFloat(imgSize)
            imageViewWidthConstraint.constant = CGFloat(imgSize)
        }
    }

    override func awakeFromNib() {
        updateInterfaceForDynamicTypeSize()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateInterfaceForDynamicTypeSize",
            name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
