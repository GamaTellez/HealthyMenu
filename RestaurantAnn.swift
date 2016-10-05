//
//  RestaurantAnn.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/4/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import MapKit

/****************************************************
 * A custom class that represents the restaurants 
 * near the user in the map
 ***************************************************/


class RestautantAnn : NSObject, MKAnnotation {
    let restuarantName: String
    let coordinate: CLLocationCoordinate2D
    
    init(nameOfRestaurant:String, coordinate:CLLocationCoordinate2D) {
        self.restuarantName = nameOfRestaurant
        self.coordinate = coordinate
        super.init()
    }
    
}
