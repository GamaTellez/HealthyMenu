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
import Gecco

class HomeView: UIViewController, NewMealCreatedDelegate, NewGoalCreatedDelegate, NewDayDelegate, mealSearchDelegate {
    
    @IBOutlet var currentProteinCountLabel: CircularProgressLabel!
    @IBOutlet var currentCaloriesLabel: CircledLabel!
    @IBOutlet var addProtein: UIButton!
    @IBOutlet var goalStats: UIBarButtonItem!
    @IBOutlet var proteinTitleLabel: UILabel!
    @IBOutlet var caloriesTitleLabel: UILabel!
    @IBOutlet var settingsBarButtonItem: UIBarButtonItem!
    lazy var defaults = UserDefaults()
    @IBOutlet var newGoalButton: UIBarButtonItem!
    var currentGoal:Goal?
    var navBarTitleButton:UIButton = UIButton(type: .custom)
    var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer()
    let kFirstLaunch = "firstLaunch"
    
    override func viewDidLoad() {
        self.setUpViews()
        self.loadInfoInViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.isFirstLaunch()
    }
    /********************************************************
     * firstLaunch
     *********************************************************/
    private func isFirstLaunch() {
        guard let _ = self.defaults.value(forKey: self.kFirstLaunch) else {
            let firstLaunchAlert = UIAlertController(title: "Thank you for downloading \"Protein journal\"", message: "We would you like to see this mini walk through", preferredStyle: .alert)
            firstLaunchAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                self.defaults.set(false, forKey: self.kFirstLaunch)
                let walkThroughController = AppWalkThrouhController()
                self.present(walkThroughController, animated: true, completion: nil)
            }))
            self.present(firstLaunchAlert, animated: true, completion: nil)
            return
        }
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
        self.navigationController?.addStatusBarView()
        self.setAppBackGroundColor()
        self.goalStats.image = UIImage(named: "chart")
        self.newGoalButton.image = UIImage(named:"goalIcon")
       // self.goalStats.tintColor = UIColor.black
        self.navBarTitleButton.sizeToFit()
        self.navBarTitleButton.addTarget(self, action: #selector(self.titleButtontapped), for: UIControlEvents.touchUpInside)
        self.navBarTitleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.navBarTitleButton.setTitle("Current Day", for: .disabled)
        self.navBarTitleButton.setTitleColor(UIColor.white, for: .disabled)
        self.navigationItem.titleView = self.navBarTitleButton
        self.tapGestureRecognizer.numberOfTapsRequired = 2
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.hideShowNavBar))
        self.proteinTitleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 25)
        self.proteinTitleLabel.textColor = UIColor.white
        self.caloriesTitleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 25)
        self.caloriesTitleLabel.textColor = UIColor.white
        self.addProtein.titleLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.addProtein.setTitle("Add Meal", for: .normal)
        self.addProtein.setTitleColor(UIColor.white, for: .normal)
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
        self.navigationController?.navigationBar.isTranslucent = false
        self.settingsBarButtonItem.image = UIImage(named:"settings")
        
    }

    
    /*********************************************************
     * called when user taps, sets the nav bar property hidden 
     * as desired
     **********************************************************/
    @objc private func hideShowNavBar() {
        guard let navController = self.navigationController else { return }
        if (navController.navigationBar.isHidden == true) {
            navController.setNavigationBarHidden(false, animated: true)
        } else if (navController.navigationBar.isHidden == false) {
            navController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    /*********************************************************
     * title button tapped
     **********************************************************/
    @objc private func titleButtontapped() {
        self.tapGestureRecognizer.removeTarget(self, action: #selector(self.hideShowNavBar))
        let resetView:ResetDayView = ResetDayView(frame: self.view.frame, distanceFromTop: (self.navigationController?.navigationBar.frame.height)! + 20)
        resetView.delegate = self
        resetView.show()
        self.view.addSubview(resetView)
    }
    
    /*********************************************************
     * add protein button tapped
     **********************************************************/
    @IBAction func addProteinButtonTapped(_ sender: UIButton) {
        self.tapGestureRecognizer.removeTarget(self, action: #selector(self.hideShowNavBar))
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
        newGoalView.present(to: self.currentProteinCountLabel.center)
    }
    
    
    @objc private func enterMealManually() {
        self.tapGestureRecognizer.removeTarget(self, action: #selector(self.hideShowNavBar))
        let addMealCustomView = AddMealView(frame: self.view.frame)
        addMealCustomView.delegate = self
        self.view.addSubview(addMealCustomView)
        addMealCustomView.present(toPoint: self.currentProteinCountLabel.center)
    }
    
    
    /**********************************************************
     * presents an alert view like with options on how to add 
     * the new meal
     ***********************************************************/
    @objc private func searchMeal() {
        guard let searchMealViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMealController") as? MealSearchViewController else { return }
        searchMealViewController.delegate = self
        self.present(searchMealViewController, animated: true, completion: nil)
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
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.hideShowNavBar))
    }
    func noMealWasCreated() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.hideShowNavBar))
    }
    
    /**********************************************************
     * newGoalCreatedDelegate
     ***********************************************************/
    func newGoalCreated(with proteinGoal: Int16, isCurrent: Bool) {
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
     * search meal delegate
     ***********************************************************/
    func mealFound(protein: Int, calories: Int, name: String) {
        guard let currentDayInview = self.currentGoal?.getCurrentyDay() else { return }
        NSManagedObject.createMeal(protein: Int16(protein), calories: Int16(calories), name: name, day: currentDayInview) { (mealCreated) in
            if (mealCreated) {
                self.currentGoal?.getCurrentyDay()?.calculateTotals()
                self.currentProteinCountLabel.update()
                self.currentCaloriesLabel.update()
            }
        }
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.hideShowNavBar))
    }
}










