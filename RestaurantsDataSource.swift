//
//  RestaurantsDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/15/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class RestaurantsDataSource: NSObject, UITableViewDataSource {
    private(set) var restaurantsFound:[Restaurant] = [Restaurant]()
    let restaurantCellID = "restaurantCell"
    
    internal func updateRestaurantsDataSource(restaurantsFound:[Restaurant]?) {
        guard let newRestaurants = restaurantsFound  else {
            self.restaurantsFound = []
            return
        }
        self.restaurantsFound = newRestaurants
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantsFound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantAtIndex = self.restaurantsFound[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.restaurantCellID, for: indexPath)
        cell.textLabel?.text = restaurantAtIndex.name
        cell.detailTextLabel?.text = String(format: "Distance: %.1f miles", restaurantAtIndex.distanceFromUser!)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
        
}
