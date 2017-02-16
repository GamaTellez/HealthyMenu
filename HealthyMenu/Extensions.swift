//
//  Extensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension URLSession {
    func performNutrionixSearch(textToSearch: String, completion:@escaping (_ results:[NSDictionary]?)-> Void) {
        let kNutrionixAppId = "f8baaf08"
        let kNutrionixApplicationKey = "3de37b0ec22fc6ebf375c8911b6938ba"
        let kNutrionixSearchEndPoint = "https://api.nutritionix.com/v1_1/search/" + textToSearch.replacingOccurrences(of: " ", with: "%") + "?results=0%3A50&cal_min=100&cal_max=50000&fields=item_name%2Cbrand_name%2Cnf_calories%2Cnf_protein&appId=" + kNutrionixAppId + "&appKey=" + kNutrionixApplicationKey
        guard let urlForRequest:URL = URL(string: kNutrionixSearchEndPoint) else {
            completion(nil)
            return
        }
        let menuTask = URLSession.shared.dataTask(with: urlForRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                completion(nil)
                return
            }
            do {
                let menuJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                //print(menuJson)
                guard let resultsArray = menuJson["hits"] as? [NSDictionary] else {
                    completion(nil)
                    return
                }
                completion(resultsArray)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        menuTask.resume()
    }
}

extension NSEntityDescription {
    func createEntityDay() -> NSEntityDescription? {
        guard let dayEntity = NSEntityDescription.entity(forEntityName: "Day", in: PersistantStorageCoordinator().context) else {
            return nil
        }
        return dayEntity
    }
    
    func createGoalEntity() -> NSEntityDescription? {
        guard let goalEntity = NSEntityDescription.entity(forEntityName: "Goal", in: PersistantStorageCoordinator().context) else {
            return nil
        }
        return goalEntity
    }
    
    func createMealEntity() -> NSEntityDescription? {
        guard let mealEntity = NSEntityDescription.entity(forEntityName: "Meal", in: PersistantStorageCoordinator().context) else {
            return nil
        }
        return mealEntity
    }

}

extension NSManagedObject {
    func createDay()-> Day {
        return NSEntityDescription.insertNewObject(forEntityName: "Day", into: PersistantStorageCoordinator().context) as! Day
    }
    
    func createGoal()-> Goal {
        return NSEntityDescription.insertNewObject(forEntityName: "Goal", into: PersistantStorageCoordinator().context) as! Goal
    }
    
    func createMeal()-> Meal {
         return NSEntityDescription.insertNewObject(forEntityName: "Meal", into: PersistantStorageCoordinator().context) as! Meal
    }
}


extension NSFetchRequest {
    func getCurrentDay()-> Day? {
        let daysRequest:NSFetchRequest<Day> = Day.fetchRequest()
        let dayDescriptor = NSSortDescriptor(key: "date", ascending: false)
        daysRequest.sortDescriptors = [dayDescriptor]
        do {
            let days = try PersistantStorageCoordinator().context.fetch(daysRequest)
            return days[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
//    func getCurrentGoal()-> Goal? {
//        let goalRequest:NSFetchRequest<Goal> = Goal.fetchRequest()
//        do {
//            let goals = try PersistantStorageCoordinator().context.fetch(goalRequest)
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}

extension Goal {
    func getCurrentDay()-> Day? {
        let daySorter = NSSortDescriptor(key: "date", ascending: false)
        let sortedDays = self.days?.sortedArray(using: [daySorter]) as? [Day]
        guard sortedDays != nil else {
            return nil
        }
        return sortedDays?[0]
    }
}







