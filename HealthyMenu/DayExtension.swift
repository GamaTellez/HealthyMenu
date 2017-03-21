//
//  DayExtension.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/16/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import CoreData

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
