//
//  MealSearhResultCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/13/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MealSearhResultCell: UITableViewCell {

    @IBOutlet var mealName: UILabel!
    @IBOutlet var mealBrandName: UILabel!
    @IBOutlet var mealCalories: UILabel!
    @IBOutlet var mealProtein: UILabel!

        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mealProtein.layer.cornerRadius = self.mealProtein.frame.width / 2
        self.mealProtein.layer.borderWidth = 1
        
        self.mealCalories.layer.cornerRadius = self.mealProtein.frame.width / 2
        self.mealCalories.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
