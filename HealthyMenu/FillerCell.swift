//
//  FillerCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/13/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class FillerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
