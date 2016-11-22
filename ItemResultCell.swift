//
//  ItemResultCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class ItemResultCell: UITableViewCell {

    @IBOutlet var itemProteinLabel: UILabel!
    @IBOutlet var itemCaloriesLabel: UILabel!
    @IBOutlet var itemBrandLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
