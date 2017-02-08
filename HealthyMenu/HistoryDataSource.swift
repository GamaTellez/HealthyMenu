//
//  HistoryDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 1/23/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class HistoryDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
