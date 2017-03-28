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
    
    @IBOutlet var goalsTitleLabel: UILabel!
    @IBOutlet var circularChart: GoalDaysCircularChart!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var caloriesAvarageLabel: UILabel!
    @IBOutlet var proteinAvarageLabel: UILabel!
    var allGoals:[Goal]?
    let pickerViewDataSource:GoalsPickerViewDataSource = GoalsPickerViewDataSource()
    @IBOutlet var goalsPickerView: UIPickerView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var proteinTitleLabel: UILabel!
    @IBOutlet var caloriesTitleLabel: UILabel!
    @IBOutlet var goalReachedTag: UILabel!
    @IBOutlet var totalDaysTag: UILabel!
    @IBOutlet var goalReachedTitleLabel: UILabel!
    @IBOutlet var totalDaysTitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfoInViews()
        self.setUpViews()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
        self.proteinAvarageLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 15)
        self.proteinAvarageLabel.textColor = UIColor.white
        self.caloriesAvarageLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 15)
        self.caloriesAvarageLabel.textColor = UIColor.white
        self.titleLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.titleLabel.textColor = UIColor.white
        self.closeButton.setImage(UIImage(named: "closeIcon"), for: UIControlState.normal)
        self.closeButton.clipsToBounds = true
        self.proteinTitleLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.proteinTitleLabel.textColor = UIColor.white
        self.caloriesTitleLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.caloriesTitleLabel.textColor = UIColor.white
        self.goalsPickerView.backgroundColor = UIColor(red: 0.494, green: 0.494, blue: 0.494, alpha: 1.00)
        self.goalsTitleLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.goalsTitleLabel.textColor = UIColor.white
        self.goalReachedTag.backgroundColor = UIColor(red: 0.325, green: 0.957, blue: 0.259, alpha: 1.00)
        self.totalDaysTag.backgroundColor = UIColor.gray
        self.goalReachedTitleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 15)
        self.goalReachedTitleLabel.numberOfLines = 2
        self.goalReachedTitleLabel.textColor = UIColor.white
        self.totalDaysTitleLabel.font =  UIFont(name: "HelveticaNeue-CondensedBold", size: 15)
        self.totalDaysTitleLabel.textColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var index = 0
        guard self.allGoals != nil else { return }
        for goal in self.allGoals! {
            if goal.isCurrentGoal {
                self.goalsPickerView.selectRow(index, inComponent: 0, animated: true)
                self.circularChart.animate(totalDays: Double((goal.days?.count)!), totalDaysGoalWasReached: Double(goal.getDaysGoalWasReached()!))
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
        print(totalDays)
        print(daysGoalWasReached)
        self.circularChart.animate(totalDays: Double((totalDays)), totalDaysGoalWasReached: Double(daysGoalWasReached))
        
        guard let avarageProtein = goalSelected.getProteinAvarage() else {
            return
        }
        self.proteinAvarageLabel.text = String(format:"%d g.", avarageProtein)
        guard let avarageCaloies = goalSelected.getCaloriesAvarage() else {
            return
        }
        self.caloriesAvarageLabel.text = String(format:"%d g.", avarageCaloies)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
