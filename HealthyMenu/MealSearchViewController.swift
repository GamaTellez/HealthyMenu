//
//  MealSearchViewController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/14/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData


protocol mealSearchDelegate {
    func mealFound(protein:Int, calories:Int, name:String)
}


class MealSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var mealSearchBar: UISearchBar!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var sorterSegmentController: UISegmentedControl!
    @IBOutlet var tableViewSearchResults: UITableView!
    var delegate:mealSearchDelegate?
    
    
    var urlSession = URLSession.shared
    var searchResults:[SearchResultItem] = [SearchResultItem]()
    var itemSelected:SearchResultItem?
    var activityIndicator:ActivityIndicatorView = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let cellResultID = "cellResultID"
    let cellFillerID = "cellFillerID"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.view.backgroundColor = UIColor.black
    }

    private func setupViews() {
        self.tableViewSearchResults.delegate = self
        self.tableViewSearchResults.dataSource = self
        self.backGroundView.layer.cornerRadius = 10
        self.backGroundView.layer.borderWidth = 1
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.tintColor = UIColor.white
        self.mealSearchBar.barTintColor = UIColor.white
        self.mealSearchBar.tintColor = UIColor.black
        self.mealSearchBar.searchBarStyle = .prominent
    }
    
  
    /**********************************************************
     * SEARCH BAR DELEGATE METHODS
     ***********************************************************/
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.view.center
        self.activityIndicator.start()
        guard let textToSarchFor = searchBar.text else {
            return
        }
        self.urlSession.performNutrionixSearch(textToSearch: textToSarchFor) { (results) in
            guard let searchResults = results else {
                print("there was an error in the search. present alert controller")
                return
            }
            self.searchResults.removeAll()
            for infoDict in searchResults {
                guard let dict = infoDict.value(forKey: "fields") as? NSDictionary else {
                    print("there was not dict with info")
                    return
                }
                self.searchResults.append(SearchResultItem(infoDictionary: dict))
            }
            DispatchQueue.main.async {
                self.tableViewSearchResults.reloadData()
                self.activityIndicator.stop()
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    /**********************************************************
     * TABLEVIEW DATASOURCE METHODS
     ***********************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 != 0) {
            guard let cellFiller = tableView.dequeueReusableCell(withIdentifier: self.cellFillerID) else {
                tableView.register( UINib(nibName: "FillerCell", bundle: nil), forCellReuseIdentifier: self.cellFillerID)
                let cellFiller = tableView.dequeueReusableCell(withIdentifier: self.cellFillerID) as? FillerCell
                return cellFiller!
            }
            return cellFiller
        } else {
            guard let cellSearchItemCell = tableView.dequeueReusableCell(withIdentifier: self.cellResultID) as? MealSearhResultCell else {
                tableView.register(UINib(nibName: "MealSearhResultCell", bundle: nil), forCellReuseIdentifier: self.cellResultID)
                let cellResult = tableView.dequeueReusableCell(withIdentifier: self.cellResultID) as? MealSearhResultCell
                let currentSearchItem = self.searchResults[indexPath.row]
                self.fillCellInfo(searchItem: currentSearchItem, cell: cellResult!)
                return cellResult!
            }
            let currentSearchItem = self.searchResults[indexPath.row]
            self.fillCellInfo(searchItem: currentSearchItem, cell: cellSearchItemCell)
            return cellSearchItemCell
        }
    }
    
    /**********************************************************
     * TABLEVIEW DELEGATE METHODS
     ***********************************************************/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row % 2 != 0) {
            return 10
        }
        else {
            return 174
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newItemSelected = self.searchResults[indexPath.row]
        self.itemSelected = newItemSelected
        let itemSelectedAlert = UIAlertController(title: "Save Meal", message: "", preferredStyle: .alert)
        itemSelectedAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        itemSelectedAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: { 
                    if (self.delegate != nil) {
                        self.delegate?.mealFound(protein: newItemSelected.itemProtein!, calories: newItemSelected.itemCalories!, name: newItemSelected.itemName!)
                    }
                })
        }))
        self.present(itemSelectedAlert, animated: true, completion: nil)
    }
    
    
    private func fillCellInfo(searchItem:SearchResultItem, cell:MealSearhResultCell) {
        guard let mealName = searchItem.itemName else {
            cell.mealName.text = "Not found"
            return
        }
        cell.mealName.text = mealName
        guard let mealBrand = searchItem.itemBrandName else {
            cell.mealBrandName.text = "Not found"
            return
        }
        cell.mealBrandName.text = mealBrand
        guard let mealCalories = searchItem.itemCalories else {
            cell.mealCalories.text = "Not found"
            return
        }
        cell.mealCalories.text = String(format:"%d", mealCalories)
        guard let mealProtein = searchItem.itemProtein else {
            cell.mealProtein.text = "Not found"
            return
        }
        cell.mealProtein.text = String(format:"%d", mealProtein)
    }

}
