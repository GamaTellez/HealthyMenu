//
//  SettingsDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/29/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appWalkThrough", for: indexPath)
        cell.textLabel?.text = "Start"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "App Walkthrough"
    }
}
