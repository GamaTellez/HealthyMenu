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
    
    @IBOutlet var scrollView: UIScrollView!
    var allGoals:[Goal]?
    let pickerViewDataSource:GoalsPickerViewDataSource = GoalsPickerViewDataSource()
    @IBOutlet var goalsPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPickerView()
    }
    
    private func setUpPickerView() {
        self.goalsPickerView.dataSource = self.pickerViewDataSource
        guard let goalsSaved = NSFetchRequest<NSFetchRequestResult>.getAllGoals() else {
            return
        }
        self.allGoals = goalsSaved
        self.pickerViewDataSource.updateGoalsArrayDataSource(goals: goalsSaved)
        self.goalsPickerView.reloadAllComponents()
        self.setUpPieChartForGoal(totalDays: 34.0)
    }
    
    private func setUpPieChartForGoal(totalDays:CGFloat) {
        var daysSlice = Piechart.Slice()
        daysSlice.value = totalDays
        daysSlice.color = UIColor.blue
        daysSlice.text = "Total Days"
        
        var daysReachedSlice = Piechart.Slice()
        daysReachedSlice.value = totalDays / 3
        daysReachedSlice.color = UIColor.green
        daysReachedSlice.text = "Goal Reached"
        
        let pieChartForCurrentGoal = Piechart()
        pieChartForCurrentGoal.delegate = self
        pieChartForCurrentGoal.radius.outer = self.view.frame.width / 4
        pieChartForCurrentGoal.radius.inner = self.view.frame.width / 5
        pieChartForCurrentGoal.title = "Goal Reached"
        pieChartForCurrentGoal.activeSlice = 0
        pieChartForCurrentGoal.slices = [daysSlice, daysReachedSlice]
        
        var views: [String: UIView] = [:]
        pieChartForCurrentGoal.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pieChartForCurrentGoal)
        views["piechart"] = pieChartForCurrentGoal
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[piechart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[piechart(==200)]", options: [], metrics: nil, views: views))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let proteinGoal = self.allGoals?[row].proteinGoal else {
            return "Not Found"
        }
        return String(format:"%d", Int(proteinGoal))
    }
    
    func setSubtitle(_ total: CGFloat, slice: Piechart.Slice) -> String {
           return "\(Int(slice.value / total * 100))% \(slice.text!)"
    }
    
    func setInfo(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return "Reached"
    }
}
