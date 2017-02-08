//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController, NewMealCreatedDelegate{
    
    @IBOutlet var currentProteinCountLabel: CircularProgressLabel!
    @IBOutlet var decrease: UIButton!
    @IBOutlet var increase: UIButton!
    @IBOutlet var currentCaloriesLabel: CircledLabel!
    @IBOutlet var addProtein: UIButton!
    @IBOutlet var viewHistory: UIBarButtonItem!
    var timer: Timer!
    var navBarTitleButton:UIButton = UIButton(type: .custom)
    
    
    
    override func viewDidLoad() {
        self.increase.addTarget(self, action: #selector(self.add), for: UIControlEvents.touchDown)
        self.increase.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
        self.decrease.addTarget(self, action: #selector(self.substract), for: UIControlEvents.touchDown)
        self.decrease.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
        self.setUpViews()
    }
    
    /*********************************************************
    * setting up the views
    **********************************************************/
    private func setUpViews() {
        self.viewHistory.image = UIImage(named: "History")
        self.viewHistory.tintColor = UIColor.black
        self.navBarTitleButton.backgroundColor = UIColor.red
        self.navBarTitleButton.setTitle("Friday January 12", for: .normal)
        self.navBarTitleButton.sizeToFit()
        self.navBarTitleButton.addTarget(self, action: #selector(self.titleButtontapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = self.navBarTitleButton
    }
    
    /*********************************************************
     * title button tapped
     **********************************************************/
    @objc private func titleButtontapped() {
        let resetView:ReseyDayView = ReseyDayView(frame: self.view.frame, distanceFromTop: (self.navigationController?.navigationBar.frame.height)! + 20, selector: #selector(self.resetDay), viewController:self)
        resetView.show()
        self.view.addSubview(resetView)
        self.navBarTitleButton.isEnabled = false
    }
    
    /*********************************************************
     * add protein button tapped
     **********************************************************/
    @IBAction func addProteinButtonTapped(_ sender: UIButton) {
        let addProteinOptionsView = AddProteinOptionsView(frame: self.view.frame, viewController: self, searchMealSelector: #selector(self.searchMeal), enterManuallySelector: #selector(self.enterMealManually))
        self.view.addSubview(addProteinOptionsView)
        addProteinOptionsView.presentView()
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
    func newMealCreated(mealCreated: Bool)-> Void {
        
    }
    
    func substract() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.currentProteinCountLabel.completed -= 1
            self.currentProteinCountLabel.text = String(format:"%.2f", self.currentProteinCountLabel.completed)
        })
    }
    
    func stop() {
        self.timer.invalidate()
    }
    
    func add() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.currentProteinCountLabel.completed += 1
            self.currentProteinCountLabel.text = String(format:"%.2f", self.currentProteinCountLabel.completed)
        })
    }
    
    /**********************************************************
     * viewHistoryButtonTapped
     ***********************************************************/
    @IBAction func viewHistoryButtonTapped(_ sender: Any) {
        
    }
    
    /**********************************************************
     * resetDayAlert
     ***********************************************************/
//    private func presentResetDayAlertController() -> Void {
//        let resetDayAlert = UIAlertController(title: "Reset Count", message: "Do you want to reset your protein count? (it will add a new day to your protein goal", preferredStyle: .alert)
//        resetDayAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
//        resetDayAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action:UIAlertAction) in
//            self.resetDay()
//        }))
//      resetDayAlert.view.backgroundColor = UIColor.clear
//        self.navigationController?.present(resetDayAlert, animated: true, completion: nil)
//    }
    
    /**********************************************************
     * resetDay
     ***********************************************************/
    func resetDay() {
        if (!self.navBarTitleButton.isEnabled) {
            self.navBarTitleButton.isEnabled = true
        }
    }

}










