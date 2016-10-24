//
//  MenusDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MenusDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
