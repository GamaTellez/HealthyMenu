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
        newDay.isCurrentDay = true
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
        newDayForNewGoal.isCurrentDay = true
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
    
    static func createMeal(protein:Int16, calories:Int16, name:String, day:Day, completion:(_ success:Bool)-> Void) {
         let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: PersistantStorageCoordinator().context) as! Meal
        newMeal.protein = protein
        newMeal.calories = calories
        newMeal.name = name
        newMeal.day = day
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
        do {
            let days = try PersistantStorageCoordinator().context.fetch(daysRequest)
            for day in days {
                if (day.isCurrentDay) {
                    return day
                }
            }
            return nil
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
                }
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getAllGoals() -> [Goal]? {
        do {
            let allGoals = try PersistantStorageCoordinator().context.fetch(Goal.fetchRequest())
            return allGoals as? [Goal]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Goal {
    func getCurrentyDay()-> Day? {
        let daysRequest:NSFetchRequest<Day> = Day.fetchRequest()
        do {
            let days = try PersistantStorageCoordinator().context.fetch(daysRequest)
            for day in days {
                if (day.isCurrentDay) {
                    return day
                }
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Day {
    internal func calculateTotals() {
        self.calcProteinTotal()
        self.calcCaloriesTotal()
    }
    
   private func calcProteinTotal() {
        guard let allMeals = self.meals?.allObjects as? [Meal] else {
            return
        }
        self.proteinCount = 0
        for meal in allMeals {
            self.proteinCount += meal.protein
        }
        PersistantStorageCoordinator().save { (success) in
            if (success) {
                    print("protein total calculated")
            }
        }
    }
    
    private func calcCaloriesTotal() {
        guard let allMeals = self.meals?.allObjects as? [Meal] else {
            return
        }
        self.caloriesCount = 0
        for meal in allMeals {
            self.caloriesCount += meal.calories
        }
        PersistantStorageCoordinator().save { (success) in
            if (success) {
                print("caloies total calculated")
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
