//
//  MenuItem.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/24/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation


class MenuItem {
    let caloriesKey = "nf_calories"
    let proteinKey = "nf_protein"
    let nameKey = "item_name"
    
    private(set) var itemName:String?
    private(set) var itemCalories:Int?
    private(set) var itemProtein:Int?
    private(set) var restaurant:Restaurant?
    private(set) var itemID:Int?
    
    
    init(infoDictionary:NSDictionary) {
        guard let name = infoDictionary.value(forKey: "item_name") as? String else {
            self.itemName = "Not found"
            return
        }
        self.itemName = name
        guard let calories = infoDictionary.value(forKey: "nf_calories") as? Int else {
            self.itemCalories = 0
            return
        }
        self.itemCalories = calories
        guard let protein = infoDictionary.value(forKey: "nf_protein") as? Int else {
            self.itemProtein = 0
            return
        }
        self.itemProtein = protein
    }
}
