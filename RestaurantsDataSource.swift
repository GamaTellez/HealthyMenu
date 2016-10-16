//
//  RestaurantsDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/15/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class RestaurantsDataSource: NSObject, UICollectionViewDataSource {
    private(set) var restaurantsFound:[Restaurant] = [Restaurant]()
    let restaurantCollectionCellID = "restaurantCollectionCell"
    
    internal func updateRestaurantsDataSource(restaurantsFound:[Restaurant]?) {
        guard let newRestaurants = restaurantsFound  else {
            self.restaurantsFound = []
            return
        }
        self.restaurantsFound = newRestaurants
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantsFound.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.restaurantCollectionCellID, for: indexPath) as! RestaurantCollectionCell
        cell.updateCellContents(forRestaurant: self.restaurantsFound[indexPath.row])
        return cell
    }
}
