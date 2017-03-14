//
//  MealSearhResultCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/13/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MealSearhResultCell: UITableViewCell {

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemBrandNameLabel: UILabel!
    @IBOutlet var itemCaloriesLabel: UILabel!
    @IBOutlet var itemProteinLabel: UILabel!
    

        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
