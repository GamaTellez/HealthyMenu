//
//  ManagedObjectExtensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/16/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import CoreData

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
    
    static func createMealFromSearchItemResult(item:SearchResultItem, completion:(_ saved:Bool)-> Void) {
        let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: PersistantStorageCoordinator().context) as! Meal
        guard let protein = item.itemProtein else {
            newMeal.protein = 0
            return
        }
        guard let calories = item.itemCalories else {
            newMeal.calories = 0
            return
        }
        guard let name = item.itemName else {
            newMeal.name = "Not Available"
            return
        }
        newMeal.calories = Int16(calories)
        newMeal.protein = Int16(protein)
        newMeal.name = name
        PersistantStorageCoordinator().save { (saved:Bool) in
            if (saved) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

