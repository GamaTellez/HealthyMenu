//
//  Goal.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/10/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import CoreData

class Goal:NSManagedObject {
    @NSManaged var proteinGoal:NSNumber?
    @NSManaged var proteinCount:NSNumber?
    @NSManaged var caloriesCount:NSNumber?
    
}
