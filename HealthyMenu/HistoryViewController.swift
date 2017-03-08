//
//  HistoryViewController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/23/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UIPickerViewDelegate, PiechartDelegate {
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var coverView: UIView!
    @IBOutlet var caloriesAvarageLabel: UILabel!
    @IBOutlet var proteinAvarageLabel: UILabel!
    var allGoals:[Goal]?
    let pickerViewDataSource:GoalsPickerViewDataSource = GoalsPickerViewDataSource()
    let pieChartForCurrentGoal:Piechart = Piechart()
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
        self.setUpPieChartForGoal(totalDays: CGFloat(totalDays), daysReached: CGFloat(daysGoalWasReached))
        guard let avarageProtein = goalSelected.getProteinAvarage() else {
            return
        }
        self.proteinAvarageLabel.text = String(format:"%d", avarageProtein)
        guard let avarageCaloies = goalSelected.getCaloriesAvarage() else {
            return
        }
        self.caloriesAvarageLabel.text = String(format:"%d", avarageCaloies)
    }
    
    private func setUpPieChartForGoal(totalDays:CGFloat, daysReached:CGFloat) {
        var daysSlice = Piechart.Slice()
        daysSlice.value = totalDays
        daysSlice.color = UIColor.blue
        
        var daysReachedSlice = Piechart.Slice()
        daysReachedSlice.value = daysReached
        daysReachedSlice.color = UIColor.green
        daysReachedSlice.text = "Days With Goal"
        
        self.pieChartForCurrentGoal.delegate = self
        self.pieChartForCurrentGoal.radius.outer = self.view.frame.width / 3.8
        self.pieChartForCurrentGoal.radius.inner = self.view.frame.width / 5
        self.pieChartForCurrentGoal.activeSlice = 1
        self.pieChartForCurrentGoal.title = String(format:"Goal reached %d \n days of %d", Int(daysReached), Int(totalDays))
        self.pieChartForCurrentGoal.slices = [daysSlice, daysReachedSlice]
        var views: [String: UIView] = [:]
        self.pieChartForCurrentGoal.translatesAutoresizingMaskIntoConstraints = false
        self.coverView.addSubview(self.pieChartForCurrentGoal)
        views["piechart"] = self.pieChartForCurrentGoal
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[piechart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[piechart(==200)]", options: [], metrics: nil, views: views))
    }
    
    
    func setSubtitle(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return ""
    }
    
    func setInfo(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return ""
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
