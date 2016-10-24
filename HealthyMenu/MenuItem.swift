//
//  MenuItem.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/24/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation


class MenuItem {
    private(set) var itemName:String?
    private(set) var restaurant:Restaurant?
    
    init(itemName:String?, restaurantName:String?) {
        self.setName(name: itemName)
    }
    
    private func setName(name:String?) {
        guard name != nil else {
            self.itemName = "Not available"
            return
        }
        self.itemName = name
    }
}
