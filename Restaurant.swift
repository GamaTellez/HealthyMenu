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
    private(set) var distanceFromUser:Double?
    private(set) var userLocation:CLLocation?
    private(set) var menu:[MenuItem]?
    
    init(name:String?, address:String?, location:CLLocation?, userLocation:CLLocation?) {
        self.setName(name: name)
        self.setAddress(address: address)
        self.setLocation(location: location)
        self.setUserLocation(userLocation: userLocation)
        self.setDistanceToUser()
    }
    
    internal func setName(name:String?) {
        guard name != nil else {
            self.name = nil
            return
        }
        self.name = name
    }
    
    internal func setAddress(address:String?) {
        guard address != nil else {
            self.address = nil
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
    
    internal func setUserLocation(userLocation:CLLocation?) {
        guard userLocation != nil else {
            self.userLocation = nil
            return
        }
        self.userLocation = userLocation
    }
    
    private func setDistanceToUser() {
        guard let distanceToUser = self.location?.distance(from: self.userLocation!) else {
            return
        }
        self.distanceFromUser = distanceToUser * 0.000621371192
    }
    
}
