//
//  Goal+CoreDataProperties.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/10/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal");
    }

    @NSManaged public var caloriesCount: Int16
    @NSManaged public var proteinCount: Int16
    @NSManaged public var proteinGoal: Int16
    @NSManaged public var days: Day?

}
