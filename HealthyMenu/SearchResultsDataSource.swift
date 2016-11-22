//
//  SearchResultsDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class SearchResultsDataSource: NSObject, UITableViewDataSource {

    let itemResultCellID = "itemResultCell"
    let fillerCellID = "fillerCell"
    private(set) var itemsSearchResults:[SearchResultItem] = [SearchResultItem]()
    
    internal func updateDataSourceArray(with menuArray:[SearchResultItem]?) {
        guard let items = menuArray else {
            return
        }
        self.itemsSearchResults = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 != 0) {
            let staticCell = tableView.dequeueReusableCell(withIdentifier: self.fillerCellID)
            return staticCell!
        } else {
            let menuItemCell = tableView.dequeueReusableCell(withIdentifier: self.itemResultCellID, for: indexPath) as? ItemResultCell
            let currentResultItem = self.itemsSearchResults[indexPath.row]
            menuItemCell?.itemNameLabel.text = currentResultItem.itemName!
            menuItemCell?.itemBrandLabel.text = currentResultItem.itemBrandName!
            menuItemCell?.itemCaloriesLabel.text = String(format: "Calories: %d", currentResultItem.itemCalories!)
            menuItemCell?.itemProteinLabel.text = String(format: "Protein: %d", currentResultItem.itemProtein!)
            return menuItemCell!
        }
    }

}
