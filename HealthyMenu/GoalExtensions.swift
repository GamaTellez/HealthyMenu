//
//  GoalExtensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/16/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import CoreData

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
        self.saveChenges()
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
    private func saveChenges() {
        PersistantStorageCoordinator().save { (saved) in
        }
    }
}
