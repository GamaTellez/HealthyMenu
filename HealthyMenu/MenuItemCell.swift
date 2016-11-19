//
//  MenuItemCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/24/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet var itemProtein: UILabel!
    @IBOutlet var itemCalories: UILabel!
    @IBOutlet var itemName: UILabel!
    private(set) var menuItem:MenuItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.itemName.lineBreakMode = .byWordWrapping
        self.itemName.numberOfLines = 2
        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
   }
