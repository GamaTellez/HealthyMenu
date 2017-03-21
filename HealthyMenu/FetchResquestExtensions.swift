//
//  FetchResquestExtensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/16/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import CoreData


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
