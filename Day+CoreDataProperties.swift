//
//  Day+CoreDataProperties.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/10/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var goal: Goal?

}
