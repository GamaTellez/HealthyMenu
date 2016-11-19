//
//  MenusDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MenusDataSource: NSObject, UITableViewDataSource {
    let cellID = "menuCell"
    private(set) var restaurantMenu:[MenuItem] = [MenuItem]()
    
    internal func updateDataSourceArray(with menuArray:[MenuItem]?) {
        guard let items = menuArray else {
            return
        }
        self.restaurantMenu = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 != 0) {
            let staticCell = tableView.dequeueReusableCell(withIdentifier: "fillerCell") 
            return staticCell!
            } else {
            let menuItemCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as? MenuItemCell
            let currentMenuItem = self.restaurantMenu[indexPath.row]
            menuItemCell?.itemName.text = currentMenuItem.itemName!
            menuItemCell?.itemCalories.text = String(format:"Calories: %d", currentMenuItem.itemCalories!)
            menuItemCell?.itemProtein.text = String(format: "Protein: %d", currentMenuItem.itemProtein!)
            return menuItemCell!
        }
    }
}
