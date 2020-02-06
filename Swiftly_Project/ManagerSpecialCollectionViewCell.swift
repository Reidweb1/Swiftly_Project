//
//  ManagerSpecialCollectionViewCell.swift
//  Swiftly_Project
//
//  Created by Reid Weber on 1/29/20.
//  Copyright © 2020 Reid Weber. All rights reserved.
//

import UIKit

class ManagerSpecialCollectionViewCell: UICollectionViewCell {
    
    /**
    * Instance Variables and IBOutlets
    */
    
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var productLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var newPriceHeight: NSLayoutConstraint!
    @IBOutlet weak var newPriceWidth: NSLayoutConstraint!
    @IBOutlet weak var oldPriceHeight: NSLayoutConstraint!
    @IBOutlet weak var oldPriceWidth: NSLayoutConstraint!

}
