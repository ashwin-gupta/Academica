//
//  CalculationCollectionViewCell.swift
//  Academica
//
//  Created by Ashwin Gupta on 10/5/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class CalculationCollectionViewCell: UICollectionViewCell {
    
    // Outlets for image and label
    @IBOutlet weak var calcLabel: UILabel!
    
    @IBOutlet weak var gpaWamLabel: UILabel!
    
    
    // Used for giving user feedback on what they have selected
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setting the design of the collection views

    }
    
}
