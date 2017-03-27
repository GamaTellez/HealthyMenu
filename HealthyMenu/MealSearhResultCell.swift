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
        self.mealBrandName.backgroundColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
        self.mealBrandName.textColor = UIColor(red: 0.329, green: 0.984, blue: 0.267, alpha: 1.00)
        self.mealBrandName.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 25)
       
        self.mealName.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.mealName.textColor = UIColor(red: 0.239, green: 0.725, blue: 0.824, alpha: 1.00)
        self.mealName.backgroundColor = UIColor(red: 0.306, green: 0.302, blue: 0.298, alpha: 1.00)
        
        self.mealCalories.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        self.mealCalories.backgroundColor = UIColor(red: 0.290, green: 0.992, blue: 0.192, alpha: 1.00)
        self.mealCalories.textColor = UIColor(red: 0.208, green: 0.204, blue: 0.204, alpha: 1.00)
        
        self.mealProtein.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        self.mealProtein.backgroundColor = UIColor(red: 0.290, green: 0.992, blue: 0.192, alpha: 1.00)
        self.mealProtein.textColor = UIColor(red: 0.208, green: 0.204, blue: 0.204, alpha: 1.00)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
