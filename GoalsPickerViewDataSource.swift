//
//  GoalsPickerViewDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/27/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class GoalsPickerViewDataSource: NSObject, UIPickerViewDataSource {
    private var allGoals:[Goal] = [Goal]()
    @available(iOS 2.0, *)
    
    internal func updateGoalsArrayDataSource(goals:[Goal]) {
        self.allGoals = goals
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allGoals.count
    }
}
