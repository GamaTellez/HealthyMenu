//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeView: UIViewController, NewMealCreatedDelegate, NewGoalCreatedDelegate, NewDayDelegate {
    
    @IBOutlet var currentProteinCountLabel: CircularProgressLabel!
    @IBOutlet var currentCaloriesLabel: CircledLabel!
    @IBOutlet var addProtein: UIButton!
    @IBOutlet var goalStats: UIBarButtonItem!
    var currentGoal:Goal?
    var navBarTitleButton:UIButton = UIButton(type: .custom)
    @IBOutlet var newGoalButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        self.setUpViews()
        self.loadInfoInViews()
    }
    
    /*********************************************************
     * setting up the views
     **********************************************************/
    private func loadInfoInViews() {
        guard let currentFetchGoal = NSFetchRequest<NSFetchRequestResult>.getCurrentGoal() else {
            self.enableViewButtons(enabled: false)
            self.navBarTitleButton.setTitleColor(UIColor.black, for: .normal)
            print("no goals have been saved")
            return
        }
        self.currentGoal = currentFetchGoal
        guard let stringDateForTitleButton = self.currentGoal?.getCurrentyDay()?.date?.readableDate() else {
            return
        }
        self.navBarTitleButton.setTitle(stringDateForTitleButton, for: .normal)
        self.currentProteinCountLabel.update()
        self.currentCaloriesLabel.update()
        self.enableViewButtons(enabled: true)
    }
    
    /************************************************************
    * enable or disable views depending on the app status
    **************************************************************/
    private func enableViewButtons(enabled:Bool) {
        self.navBarTitleButton.isEnabled = enabled
        self.addProtein.isEnabled = enabled
        self.goalStats.isEnabled = enabled
    }
    
    
    /*********************************************************
    * setting up the views
    **********************************************************/
    private func setUpViews() {
        self.goalStats.image = UIImage(named: "History")
        self.goalStats.tintColor = UIColor.black
        self.navBarTitleButton.sizeToFit()
        self.navBarTitleButton.addTarget(self, action: #selector(self.titleButtontapped), for: UIControlEvents.touchUpInside)
        self.navBarTitleButton.setTitle("Add a goal =====>", for: .disabled)
        self.navBarTitleButton.tintColor = UIColor.black
        self.navigationItem.titleView = self.navBarTitleButton
    }
    
    /*********************************************************
     * title button tapped
     **********************************************************/
    @objc private func titleButtontapped() {
        let resetView:ResetDayView = ResetDayView(frame: self.view.frame, distanceFromTop: (self.navigationController?.navigationBar.frame.height)! + 20)
        resetView.delegate = self
        resetView.show()
        self.view.addSubview(resetView)
    }
    
    /*********************************************************
     * add protein button tapped
     **********************************************************/
    @IBAction func addProteinButtonTapped(_ sender: UIButton) {
        let addProteinOptionsView = AddProteinOptionsView(frame: self.view.frame, viewController: self, searchMealSelector: #selector(self.searchMeal), enterManuallySelector: #selector(self.enterMealManually))
        self.view.addSubview(addProteinOptionsView)
        addProteinOptionsView.presentView()
    }
    
    /*********************************************************
     * new goal button tapped
     * it brings the view to add a new goal
     **********************************************************/
    @IBAction func newGoalButtonTapped(_ sender: UIBarButtonItem) {
        let newGoalView = AddGoalView(frame: self.view.frame)
        newGoalView.delegate = self
        self.view.addSubview(newGoalView)
        newGoalView.present()
    }
    
    @objc private func enterMealManually() {
        let addMealCustomView = AddMealView(frame: self.view.frame)
        addMealCustomView.delegate = self
        self.view.addSubview(addMealCustomView)
        addMealCustomView.present()
    }
    
    @objc private func searchMeal() {
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchViewController")
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }
    
    /**********************************************************
     * newMealCreatedDelegate
     ***********************************************************/
    public func newMealCreated(protein:Int16, calories:Int16, name:String)-> Void {
        guard let dayForMeal = self.currentGoal?.getCurrentyDay() else { return }
       NSManagedObject.createMeal(protein: protein, calories: calories, name: name, day: dayForMeal) { (success) in
        if (success) {
            self.currentGoal?.getCurrentyDay()?.calculateTotals()
            self.currentProteinCountLabel.update()
            self.currentCaloriesLabel.update()
            }
        }
    }
    
    /**********************************************************
     * newGoalCreatedDelegate
     ***********************************************************/
    func newGoalCreated(with proteinGoal: Int16, isCurrent: Bool) {
        NSManagedObject.checkIfGoalAlreadyExist(newProteinGoal: proteinGoal) { (oldGoal) in
            if (oldGoal != nil) {
                if (self.currentGoal != nil) {
                    self.currentGoal?.setCurrent(isCurrent: false)
                    self.currentGoal?.getCurrentyDay()?.isCurrentDay = false
                }
                oldGoal?.setCurrent(isCurrent: true)
                guard let dateString = oldGoal?.getCurrentyDay()?.date?.readableDate() else { return }
                self.navBarTitleButton.setTitle(dateString, for: .normal)
                self.currentGoal = oldGoal
                self.currentProteinCountLabel.update()
                self.currentCaloriesLabel.update()
                self.enableViewButtons(enabled: true)
            } else {
                NSManagedObject.createGoal(proteinGoal: proteinGoal, isCurrentGoal: true, completion: { (goalCreated) in
                    if (goalCreated != nil) {
                        if (self.currentGoal != nil) {
                            self.currentGoal?.setCurrent(isCurrent: false)
                            self.currentGoal?.getCurrentyDay()?.isCurrentDay = false
                        }
                        
                        goalCreated?.setCurrent(isCurrent: true)
                        self.currentGoal = goalCreated
                        guard let dateString = goalCreated?.getCurrentyDay()?.date?.readableDate() else { return }
                        self.navBarTitleButton.setTitle(dateString, for: .normal)
                        self.currentProteinCountLabel.update()
                        self.currentCaloriesLabel.update()
                        self.enableViewButtons(enabled: true)
                    } else {
                        print("couldnt create goal")
                    }
                })
            }
        }
    }
    
    
    /**********************************************************
     * newDayDelegate
     ***********************************************************/
    func newDayAdded(date: NSDate) {
        guard let currentDayInGoal = self.currentGoal?.getCurrentyDay() else { return }
        currentDayInGoal.setCurrent(current: false)
        currentDayInGoal.wasGoalReached(goal: self.currentGoal)
        NSManagedObject.createDay(date: date, goal:self.currentGoal!) { (success) in
            if (success) {
                guard let newDayDateString = self.currentGoal?.getCurrentyDay()?.date?.readableDate() else { return }
                self.navBarTitleButton.setTitle(newDayDateString, for: .normal)
                self.currentProteinCountLabel.update()
                self.currentCaloriesLabel.update()
            }
        }
    }

    /**********************************************************
     * viewHistoryButtonTapped
     ***********************************************************/
    @IBAction func viewHistoryButtonTapped(_ sender: Any) {
        
    }
}










