//
//  PersistantStorageCoordinator.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/12/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistantStorageCoordinator:NSObject {
    static let persistantStorageManager = PersistantStorageCoordinator()
    var context:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func saveToCoreData(meal: Meal) {
        do {
            try self.context.save()
        } catch let error {
            print(error.localizedDescription)
            }
        }
    }
//    func saveToCoreData(_ completion:(_ succesful:Bool) -> Void) {
//        do {
//            try self.managedContext.save()
//            completion(true)
//            // NSNotificationCenter.defaultCenter().postNotificationName(kitemSuccedsfullySaved, object: nil)
//        } catch let error as NSError {
//            completion(false)
//            print(error.localizedDescription)
//        }
//    }
