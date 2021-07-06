//
//  AssessmentTableViewCell.swift
//  Academica
//
//  Created by Ashwin Gupta on 5/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class AssessmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assessmentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
