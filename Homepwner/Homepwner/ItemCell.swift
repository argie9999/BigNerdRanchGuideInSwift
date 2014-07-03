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
    }

    override func awakeFromNib() {
        updateInterfaceForDynamicTypeSize()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateInterfaceForDynamicTypeSize",
            name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
