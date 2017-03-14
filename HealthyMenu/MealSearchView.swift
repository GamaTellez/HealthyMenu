//
//  MealSearchView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/14/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MealSearchView: UIView, UITableViewDelegate {

    @IBOutlet var mealSearchBar: UISearchBar!
    @IBOutlet var sorterSegmentController: UISegmentedControl!
    @IBOutlet var tableViewSearchResults: UITableView!
    @IBOutlet var cancelButton: UIButton!
    
    var urlSession = URLSession.shared
    var searchResults:[SearchResultItem] = [SearchResultItem]()
    var itemSelected:SearchResultItem?
    var activityIndicator:ActivityIndicatorView = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    let cellResultID = "kCellResutlID"
    let cellFillerID = "kCellFillerID"
    
    override init(frame:CGRect) {
        super.init(frame: CGRect(x: frame.origin.x + 0, y: frame.height, width: frame.width - 20, height: frame.height - 20))
        self.addSubview(self.instanceFromNib())
        self.backgroundColor = UIColor.blue
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableViewSearchResults.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func instanceFromNib()-> MealSearchView {
        return UINib(nibName: "MealSearchView", bundle: nil).instantiate(withOwner: self, options: nil).first as! MealSearchView
    }
    
    
    internal func present() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = self.superview!.center
        }, completion: {(finished:Bool) in
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y += self.superview!.frame.height
            self.alpha = 0
        }, completion: { (finished:Bool) in
            self.removeFromSuperview()
        })
    }
    
    
    
    /**********************************************************
     * SEARCH BAR DELEGATE METHODS
     ***********************************************************/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.addSubview(self.activityIndicator)
        self.activityIndicator.center = self.center
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
    
    /**********************************************************
     * TABLEVIEW DATASOURCE METHODS
     ***********************************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 != 0) {
            let fillerCell = self.tableViewSearchResults.dequeueReusableCell(withIdentifier: self.cellFillerID)
            return fillerCell!
        } else {
            let menuItemCell = tableView.dequeueReusableCell(withIdentifier: self.cellResultID, for: indexPath) as? MealSearhResultCell
            let currentResultItem = self.searchResults[indexPath.row]
            menuItemCell?.itemNameLabel.text = currentResultItem.itemName!
            menuItemCell?.itemBrandNameLabel.text = currentResultItem.itemBrandName!
            menuItemCell?.itemCaloriesLabel.text = String(format: "Calories: %d", currentResultItem.itemCalories!)
            menuItemCell?.itemProteinLabel.text = String(format: "Protein: %d", currentResultItem.itemProtein!)
            return menuItemCell!
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
            return 117
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newItemSelected = self.searchResults[indexPath.row]
        self.itemSelected = newItemSelected
        let mealSelectedAlert = MealSelectedAlertView(frame: self.frame, itemSelected:newItemSelected)
        self.addSubview(mealSelectedAlert)
        mealSelectedAlert.show()
    }
}
