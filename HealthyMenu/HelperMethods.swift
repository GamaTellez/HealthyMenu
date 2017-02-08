//
//  HelperMethods.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/28/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation

func degreesToRadians (_ value:Double) -> Double {
    return value * Double(M_PI) / 180.0
}

func radiansToDegrees (_ value:Double) -> Double {
    return value * 180.0 / Double(M_PI)
}
