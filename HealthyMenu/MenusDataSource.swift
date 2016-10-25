//
//  MenusDataSource.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MenusDataSource: NSObject, UITableViewDataSource {
    private(set) var restaurantMenu:[MenuItem] = [MenuItem]()
    
    private func updateDataSourceArray(with menuArray:[MenuItem]?) {
        guard let items = menuArray else {
            return
        }
        self.restaurantMenu = items
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
