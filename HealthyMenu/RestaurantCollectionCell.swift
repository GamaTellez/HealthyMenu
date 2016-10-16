//
//  RestaurantCollectionCell.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/15/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class RestaurantCollectionCell: UICollectionViewCell {
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLogo: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    private(set) var restaurant:Restaurant?
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func updateCellContents(forRestaurant:Restaurant) {
    self.restaurant = forRestaurant
    self.setDistanceLabel()
    self.setRestaurantName()
    }
    
    private func setRestaurantLogo() {
        
    }
    
    internal func setDistanceLabel() {
        if let userLocation = self.restaurant?.userLocation , let restaurantLocation = self.restaurant?.location {
            let distanceToUser = userLocation.distance(from: restaurantLocation)
            self.distanceLabel.text = distanceToUser.description
        } else {
            self.distanceLabel.text = "Not Available"
        }
    }
    
    internal func setRestaurantName() {
        guard let restaurantName = self.restaurant?.name else {
            self.restaurantNameLabel.text = "Not Available"
            return
        }
        self.restaurantNameLabel.text = restaurantName
    }
}
