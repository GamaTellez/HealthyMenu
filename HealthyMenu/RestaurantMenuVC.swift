//
//  RestaurantMenuVC.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 10/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class RestaurantMenuVC: UIViewController, UITableViewDelegate {

   
    @IBOutlet var filteringButton: UIBarButtonItem!
    @IBOutlet var menuTableView: UITableView!
    var restaurantSelected:Restaurant?
    var urlSession = URLSession.shared
    var menuTableDataSource = MenusDataSource()
    lazy var restaurantMenu:[MenuItem] = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row % 2 != 0) {
            return 10
        }
        else {
            return 76
        }
    }

    private func getMenuForRestaurant() {
        guard let restaurantName = self.restaurantSelected?.name else {
            self.title = self.restaurantSelected?.name
            return
        }
        self.title = restaurantName
        urlSession.findRestaurantMenu(restaurantName: restaurantName) { (menu) in
            guard let menuFound = menu else {
                print("not items found, present alert controller")
                return
                }
            for dict in menuFound {
                guard let infoDict = dict.value(forKey: "fields") as? NSDictionary else  {
                    print("there was not a dictionary with info")
                    return
                }
                self.restaurantMenu.append(MenuItem(infoDictionary: infoDict))
            }
                self.menuTableDataSource.updateDataSourceArray(with: self.restaurantMenu)
                DispatchQueue.main.sync {
                    self.menuTableView.reloadData()
                }
        }
    }
    /*****************************************************
     * setting up views
     *******************************************************/
    private func initialSetup() {
        guard let title = self.restaurantSelected?.name else {
            self.title = "Name not available"
            return
        }
        self.title = title
        self.menuTableView.dataSource = self.menuTableDataSource
        self.filteringButton.image = UIImage(named:"filter")
    }
    
    /***********************************************************
    * presents the sorting view where the user can chose the order
    * that he wants the menu to be sorted
    ***********************************************************/
    @IBAction func filterButtonTapped(_ sender: Any) {
        let sortingView = SortingOptionsView(frame: self.view.frame)
        self.view.addSubview(sortingView)
        sortingView.presentView()
    }
    
}
