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
    
    static func checkIfGoalAlreadyExist(newProteinGoal:Int16, completion:(_ existentGoal:Goal?)-> Void) {
        guard let allGoalsStored = NSFetchRequest<NSFetchRequestResult>.getAllGoals() else {
            completion(nil)
            return
        }
        for storedGoal in allGoalsStored {
            if (storedGoal.proteinGoal == newProteinGoal) {
                completion(storedGoal)
            }
        }
        completion(nil)
    }
    
    
    static func createDay(date:NSDate, goal:Goal, completion:(_ successful:Bool)-> Void) {
         let newDay = NSEntityDescription.insertNewObject(forEntityName: "Day", into: PersistantStorageCoordinator().context) as! Day
        newDay.date = date
        newDay.proteinCount = 0
        newDay.caloriesCount = 0
        newDay.isCurrentDay = true
        newDay.goal = goal
        PersistantStorageCoordinator().save { (success:Bool) in
            if (success) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func createGoal(proteinGoal:Int16, isCurrentGoal:Bool, completion:(_ newGoal:Goal?)-> Void) {
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
                completion(newGoal)
            } else {
                completion(nil)
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
    internal func getCurrentyDay()-> Day? {
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
    
   internal func getDaysGoalWasReached()-> Int? {
        var count = 0
        guard let allDays = self.days?.allObjects as? [Day] else {
                return nil
        }
        for day in allDays {
            if (day.reachedGoal) {
                count += 1
            }
        }
         return count
    }
    
    internal func setCurrent(isCurrent:Bool) {
        self.isCurrentGoal = isCurrent
    }
    
    internal func getProteinAvarage()-> Int? {
        var proteinTotal = 0
        guard let allDays = self.days?.allObjects as? [Day] else {
            return nil
        }
        for day in allDays {
            proteinTotal += Int(day.proteinCount)
        }
        return proteinTotal / allDays.count
    }
    
    internal func getCaloriesAvarage()-> Int? {
        var caloriesTotal = 0
        guard let allDays = self.days?.allObjects as? [Day] else {
            return nil
        }
        for day in allDays {
            caloriesTotal += Int(day.caloriesCount)
        }
        return caloriesTotal / allDays.count
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
    
    internal func wasGoalReached(goal:Goal?) {
        guard let currentProteinGoal = goal?.proteinGoal else { return }
        if (self.proteinCount >= currentProteinGoal) {
            self.reachedGoal = true
        } else {
            self.reachedGoal = false
        }
    }
    
    internal func setCurrent(current:Bool) {
        self.isCurrentDay = current
    }
}

extension NSDate {
    func readableDate()-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self as Date)
    }
}
