//
//  Restaurant.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/15/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Restaurant {
    private(set) var name:String?
    private(set) var address:String?
    private(set) var location:CLLocation?
    private(set) var distanceFromUser:Int?
    private(set) var userLocation:CLLocation?
    
    init(name:String?, address:String?, location:CLLocation?, userLocation:CLLocation?) {
        self.setName(name: name)
        self.setAddress(address: address)
        self.setLocation(location: location)
    }
    
    internal func setName(name:String?) {
        guard name != nil else {
            self.name = "Not Available"
            return
        }
        self.name = name
    }
    
    internal func setAddress(address:String?) {
        guard address != nil else {
            self.address = "Not Available"
            return
        }
        self.address = address
    }
    
    internal func setLocation(location:CLLocation?) {
        guard location != nil else {
            self.location = nil
            return
        }
        self.location = location
    }
        
    private func calculateDistanceToUser(userLocation:CLLocation?) -> Int {
        return 0
    }
}
