//
//  SearchViewController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UITableViewDelegate, SortingViewDelegate, UISearchBarDelegate {
    
        @IBOutlet var filteringButton: UIBarButtonItem!
        @IBOutlet var searchTableView: UITableView!
        lazy var urlSession = URLSession.shared
        var searchResultsDataSource = SearchResultsDataSource()
        lazy var searchResults:[SearchResultItem] = [SearchResultItem]()
        var itemSelected:SearchResultItem?
        lazy var activityIndicator:ActivityIndicatorView = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initialSetup()
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
                return 117
            }
        }
        
        /*****************************************************
         * setting up views
         *******************************************************/
        private func initialSetup() {
            self.filteringButton.isEnabled = false
            self.title = title
            self.searchTableView.dataSource = self.searchResultsDataSource
            self.filteringButton.image = UIImage(named:"filter")
            let searchBar = UISearchBar()
            searchBar.showsCancelButton = false
            searchBar.delegate = self
            searchBar.placeholder = "Enter your search here"
            self.navigationItem.titleView = searchBar
        }
        
        /***********************************************************
         * presents the sorting view where the user can chose the order
         * that he wants the menu to be sorted
         ***********************************************************/
        @IBAction func filteringButtonTapped(_ sender: Any) {
            let sortingView = SortingOptionsView(frame: self.view.frame)
            sortingView.delegate = self
            sortingView.searchItemsArray = self.searchResults
            self.view.addSubview(sortingView)
            sortingView.presentView()
            filteringButton.isEnabled = false
            self.searchTableView.isUserInteractionEnabled = false
    }
        /***********************************************************
         * delegate method of the sorting view
         ***********************************************************/
        func sortedArray(sortedItems: [SearchResultItem]) {
            self.filteringButton.isEnabled = true
            self.searchTableView.isUserInteractionEnabled = true
            self.searchResultsDataSource.updateDataSourceArray(with: sortedItems)
            let range = NSMakeRange(0, self.searchTableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.searchTableView.reloadSections(sections as IndexSet, with: .left)
        }
    
        /***********************************************************
        * uisearch bar delegate methods
        ***********************************************************/
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.filteringButton.isEnabled = false
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
                        self.searchResultsDataSource.updateDataSourceArray(with: self.searchResults)
                        self.searchTableView.reloadData()
                        self.activityIndicator.stop()
                        self.filteringButton.isEnabled = true
                    }
                }
        }
    
    /**********************************************************
     * tableViewDelegate methods
     ***********************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       let newItemSelected = self.searchResults[indexPath.row]
        self.itemSelected = newItemSelected
        let mealSelectedAlert = MealSelectedAlertView(frame: self.view.frame, itemSelected:newItemSelected)
        self.view.addSubview(mealSelectedAlert)
        mealSelectedAlert.show()
    }
    
    @objc private func saveSearchItem() {
        
    }
    
    
}









