//
//  RestaurantMenuVC.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class RestaurantMenuVC: UIViewController, UITableViewDelegate {

    @IBOutlet var sortingSegmentedController: UISegmentedControl!
    @IBOutlet var menuTableView: UITableView!
    var restaurantSelected:Restaurant?
    var urlSession = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMenuForRestaurant()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*****************************************************
    * tableView delegate methods                          *
    *******************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getMenuForRestaurant() {
        guard let restaurantName = self.restaurantSelected?.name else {
            self.title = self.restaurantSelected?.name
            return
        }
        self.title = restaurantName
        urlSession.findRestaurantMenu(restaurantName: restaurantName) { (menu) in
            print(menu)
        }
    }
    
    private func setUpViews() {
        guard let title = self.restaurantSelected?.name else {
            self.title = "Name not available"
            return
        }
        self.title = title
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
