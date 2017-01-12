//
//  Day_Extensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/12/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation


import Foundation
import CoreData

extension Day {
    convenience init(calories:Int, protein:Int, date:NSDate, insertIntoManagedObjectContext context:NSManagedObjectContext, entity:NSEntityDescription) {
        self.init(entity:entity, insertInto: context)
    }
    
    //    convenience init(text: String, isCorrect: Bool, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
    //        let entity = NSEntityDescription.entityForName("Alternative", inManagedObjectContext: context)!
    //        self.init(entity: entity, insertIntoManagedObjectContext: context)
    //        self.text = text
    //        self.isCorrect = isCorrect
    //    }
    //
    convenience init(calories: Int, protein:Int, date:NSDate, inserInManagedObjectContext context: NSManagedObjectContext) {
        let newDayEntity = NSEntityDescription.entity(forEntityName: "Day", in: context)!
        self.init(entity:newDayEntity, insertInto: context)
    }
    
    
}

