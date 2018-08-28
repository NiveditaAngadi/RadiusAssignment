//
//  OptionCollectionViewCell.swift
//  RadiusAssignment
//
//  Created by Nivedita on 27/08/18.
//  Copyright © 2018 RadiusAssignment. All rights reserved.
//

import UIKit

class OptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var maskOverLay: UIView!
   
    var isOptionSelected: Bool! {
        didSet {
            if self.isOptionSelected {
                self.backgroundColor = UIColor.lightGray
            }
            else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var isOptionEnabled: Bool! {
        
        didSet {
            if self.isOptionEnabled {
                self.maskOverLay.isHidden = true
                self.isUserInteractionEnabled = true
            }
            else {
                self.maskOverLay.isHidden = false
                self.isUserInteractionEnabled = false

            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
