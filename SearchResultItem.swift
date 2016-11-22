//
//  SearchResultItem.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
struct SearchResultItem {
    
    let caloriesKey = "nf_calories"
    let proteinKey = "nf_protein"
    let nameKey = "item_name"
    let brandKey = "brand_name"
    
    private(set) var itemName:String?
    private(set) var itemBrandName:String?
    private(set) var itemCalories:Int?
    private(set) var itemProtein:Int?
    private(set) var itemID:Int?
    
    
    init(infoDictionary:NSDictionary) {
        guard let name = infoDictionary.value(forKey: self.nameKey) as? String else {
            self.itemName = "Not found"
            return
        }
        self.itemName = name
        guard let brandName = infoDictionary.value(forKey: self.brandKey) as? String else {
            self.itemBrandName = "Not Found"
            return
        }
        self.itemBrandName = brandName
        guard let calories = infoDictionary.value(forKey: self.caloriesKey) as? Int else {
            self.itemCalories = 0
            return
        }
        self.itemCalories = calories
        guard let protein = infoDictionary.value(forKey: self.proteinKey) as? Int else {
            self.itemProtein = 0
            return
        }
        self.itemProtein = protein
    }
}
