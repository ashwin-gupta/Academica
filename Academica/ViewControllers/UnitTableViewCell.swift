//
//  UnitTableViewCell.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

class UnitTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
