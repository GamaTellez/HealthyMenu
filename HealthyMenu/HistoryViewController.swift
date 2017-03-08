//
//  HistoryViewController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/23/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet var circularChart: GoalDaysCircularChart!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var coverView: UIView!
    @IBOutlet var caloriesAvarageLabel: UILabel!
    @IBOutlet var proteinAvarageLabel: UILabel!
    var allGoals:[Goal]?
    let pickerViewDataSource:GoalsPickerViewDataSource = GoalsPickerViewDataSource()
    @IBOutlet var goalsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfoInViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var index = 0
        guard self.allGoals != nil else { return }
        for goal in self.allGoals! {
            if goal.isCurrentGoal {
                self.goalsPickerView.selectRow(index, inComponent: 0, animated: true)
                self.circularChart.totalOfDays = Double((goal.days?.count)!)
                self.circularChart.daysGoalWasReached = Double(goal.getDaysGoalWasReached()!)
                self.circularChart.animateToDay()
                break
            }
             index += 1
        }
    }
    
    private func loadInfoInViews() {
        guard let goalsSaved = NSFetchRequest<NSFetchRequestResult>.getAllGoals() else {
            self.allGoals = []
            self.setupPickerView(goalsArray: [])
            return
        }
        self.allGoals = goalsSaved
        self.setupPickerView(goalsArray: goalsSaved)
    }

    private func setupPickerView(goalsArray:[Goal]) {
        self.goalsPickerView.dataSource = self.pickerViewDataSource
        self.goalsPickerView.delegate = self
        self.pickerViewDataSource.updateGoalsArrayDataSource(goals: goalsArray)
        self.goalsPickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let proteinGoal = self.allGoals?[row].proteinGoal else {
            return "Not Found"
        }
        return String(format:"%d", Int(proteinGoal))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let goalSelected = self.allGoals?[row] else {
            return
        }
        guard let totalDays = goalSelected.days?.count else {
            return
        }
        guard let daysGoalWasReached = goalSelected.getDaysGoalWasReached() else {
            return
        }
        
        self.circularChart.totalOfDays = Double((totalDays))
        self.circularChart.daysGoalWasReached = Double(daysGoalWasReached)
        self.circularChart.daysFilled = 0.0
        self.circularChart.animateToDay()

        
      
        
        
        guard let avarageProtein = goalSelected.getProteinAvarage() else {
            return
        }
        self.proteinAvarageLabel.text = String(format:"%d", avarageProtein)
        guard let avarageCaloies = goalSelected.getCaloriesAvarage() else {
            return
        }
        self.caloriesAvarageLabel.text = String(format:"%d", avarageCaloies)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
