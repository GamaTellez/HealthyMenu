//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController, OptionsToAddMealDelegate, NewMealCreatedDelegate{
    @IBOutlet var currentProteinCountLabel: CircularProgressLabel!
    @IBOutlet var decrease: UIButton!
    @IBOutlet var increase: UIButton!
    var timer: Timer!
    @IBOutlet var currentCaloriesLabel: CircledLabel!
    @IBOutlet var addProtein: UIButton!
    
    
    override func viewDidLoad() {
        self.increase.addTarget(self, action: #selector(self.add), for: UIControlEvents.touchDown)
        self.increase.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
        self.decrease.addTarget(self, action: #selector(self.substract), for: UIControlEvents.touchDown)
        self.decrease.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
    }
    
    /*********************************************************
    * setting up the views
    **********************************************************/
    private func setUpViews() {
        self.addProtein.layer.cornerRadius = self.addProtein.frame.width / 2
        self.addProtein.layer.borderWidth = 1.0
        self.addProtein.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func addProteinButtonTapped(_ sender: UIButton) {
        let addProteinOptionsView = AddProteinOptionsView(frame: self.view.frame)
        self.view.addSubview(addProteinOptionsView)
        addProteinOptionsView.delegate = self
        addProteinOptionsView.presentView()
    }
    
    /**********************************************************
    * addMealDelegate method
    ***********************************************************/
    func buttonTapped(name: String) {
        if name == "Search Meal" {
            let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchViewController")
            self.navigationController?.pushViewController(searchViewController!, animated: true)
        }
        if name == "Add Meal Manually" {
            let addMealCustomView = AddMealView(frame: self.view.frame)
            addMealCustomView.delegate = self
            self.view.addSubview(addMealCustomView)
            addMealCustomView.present()
        }
    }
    
    /**********************************************************
     * newMealCreatedDelegate
     ***********************************************************/
    func newMealCreated(mealCreated: Bool)
    {
        print(mealCreated)
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
}










