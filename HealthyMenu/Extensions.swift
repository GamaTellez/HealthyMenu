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

extension NSManagedObject {
    static func createDay(date:NSDate, completion:(_ successful:Bool)-> Void) {
         let newDay = NSEntityDescription.insertNewObject(forEntityName: "Day", into: PersistantStorageCoordinator().context) as! Day
        newDay.date = date
        newDay.proteinCount = 0
        newDay.caloriesCount = 0
        PersistantStorageCoordinator().save { (success:Bool) in
            if (success) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func createGoal(proteinGoal:Int16, isCurrentGoal:Bool, completion:(_ successful:Bool)-> Void) {
        let newGoal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: PersistantStorageCoordinator().context) as! Goal
        newGoal.proteinGoal = proteinGoal
        newGoal.isCurrentGoal = isCurrentGoal
        let newDayForNewGoal = NSEntityDescription.insertNewObject(forEntityName: "Day", into:PersistantStorageCoordinator().context) as! Day
        newDayForNewGoal.date = NSDate()
        newDayForNewGoal.proteinCount = 0
        newDayForNewGoal.caloriesCount = 0
        newDayForNewGoal.goal = newGoal
        newGoal.days?.adding(newDayForNewGoal)
        PersistantStorageCoordinator().save { (success:Bool) in
            if (success) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func createMeal(protein:Int16, calories:Int16, name:String, day:Day, completion:(_ successful:Bool)-> Void) {
         let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: PersistantStorageCoordinator().context) as! Meal
        newMeal.protein = protein
        newMeal.calories = calories
        newMeal.name = name
        PersistantStorageCoordinator().save { (success:Bool) in
            if (success) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}


extension NSFetchRequest {
    static func getCurrentDay()-> Day? {
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
    
    static func getCurrentGoal()-> Goal? {
        let goalRequest:NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            let goals = try PersistantStorageCoordinator().context.fetch(goalRequest)
            for goal in goals {
                if (goal.isCurrentGoal == true) {
                    return goal
                } else {
                    return nil
                }
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return nil
    }
}

extension Goal {
    func getCurrentyDay()-> Day? {
        let sortedDaysSet = self.days?.sortedArray(using: [NSSortDescriptor(key:"date", ascending:false)])
        let sortedDayArray = sortedDaysSet as? [Day]
        guard let sortedDays = sortedDayArray else {
            return nil
        }
        if (sortedDays.isEmpty) {
            return nil
        } else {
        return sortedDays[0]
        }
    }
}

extension Day {
    func getProteinTotal() {
        guard let allMeals = self.meals?.allObjects as? [Meal] else {
            return
        }
        for meal in allMeals {
            self.proteinCount += meal.protein
        }
        PersistantStorageCoordinator().save { (success) in
            if (success) {
                    print("protein total calculated")
            }
        }
    }
}



extension NSDate {
    func readableDate()-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self as Date)
    }
}










