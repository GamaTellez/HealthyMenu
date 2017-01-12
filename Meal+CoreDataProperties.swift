//
//  Meal+CoreDataProperties.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/10/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal");
    }

    @NSManaged public var calories: Int16
    @NSManaged public var name: String?
    @NSManaged public var protein: Int16

}
