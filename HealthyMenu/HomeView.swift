//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var restaurantsMap: MKMapView!
    @IBOutlet var restaurantsTable: UITableView!
    @IBOutlet var mapListController: UISegmentedControl!
    var restaurantsTableDS = RestaurantsTableDataSource()
    var locationManager = CLLocationManager()
    let kFisrtInstall = "firstInstall"
    lazy var restaurantsRequest = MKLocalSearchRequest()
    lazy var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
//        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
        self.checkingForLocationAccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initialSetUp()
        self.checkingForLocationAccess()
    }
    
    /*****************************************
    * checking for location access
    ******************************************/
    func checkingForLocationAccess() {
        if !self.defaults.bool(forKey: self.kFisrtInstall) || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            self.requestUserLocation()
        } else {
            self.findRestaurantsNearuser()
        }
    }
    
    func requestUserLocation() {
        if (CLLocationManager.locationServicesEnabled() == true) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            print("location services are disabled")
        }
    }

    
    
    ////////////////////////////////////////
    // basic set up of view               //
    ////////////////////////////////////////
    func initialSetUp() {
        //segmented Controller
        self.mapListController.selectedSegmentIndex = 0
        self.mapListController.setTitle("Map", forSegmentAt: 0)
        self.mapListController.setTitle("List", forSegmentAt: 1)
        //tableView
        self.restaurantsTable.delegate = self
        self.restaurantsTable.dataSource = self.restaurantsTableDS
        //location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //map
        self.restaurantsMap.showsUserLocation = true
        self.restaurantsMap.delegate = self
        //search request
        self.restaurantsRequest.naturalLanguageQuery = "Restaurants"
    }
    
    
    //////////////////////////////////////
    //  Segmented Controller            //
    //////////////////////////////////////
    @IBAction func mapListSegmentTapped(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.restaurantsMap.isHidden = false
            self.restaurantsTable.isHidden = true
        }
        if (sender.selectedSegmentIndex == 1) {
            self.restaurantsMap.isHidden = true
            self.restaurantsTable.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            let deniedAlert = UIAlertController(title: "Location Needed", message: "We need to access your location to work properly", preferredStyle: .alert)
            deniedAlert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: { (opened) in
                })
            }))
            deniedAlert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in
            }))
            self.present(deniedAlert, animated:true, completion: nil)
        }
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.defaults.set(false, forKey: self.kFisrtInstall)
            self.locationManager.startUpdatingLocation()
            //self.restaurantsMap.setRegion(MKCoordinateRegionMakeWithDistance(self.restaurantsMap.userLocation.coordinate, 2000, 2000), animated: true)
            //self.findRestaurantsNearuser()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.restaurantsMap.setRegion(MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 2000,2000), animated: true)
        self.restaurantsRequest.region = MKCoordinateRegionMakeWithDistance((manager.location?.coordinate)!, 2000,2000)
        self.findRestaurantsNearuser()
    }
    
    func findRestaurantsNearuser() {
            let restaurantsSearch = MKLocalSearch(request: self.restaurantsRequest)
            restaurantsSearch.start { (localSearchResponse, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    self.errorGettingRestaurantsNearBy(with: "Error", message: (error?.localizedDescription)! , style: .alert)
                    return
                }
                guard localSearchResponse?.mapItems.count != 0 else {
                    self.errorGettingRestaurantsNearBy(with: "0 Restaurants Found", message: "There were no restaurants found near you", style: .alert)
                    return
                }
                guard let restaurantsFound = localSearchResponse?.mapItems else {
                        self.errorGettingRestaurantsNearBy(with: "Oops", message: "Something went wrong while trying to to find restaurants near you", style: .alert)
                    return
                }
                for itemRestaurant in restaurantsFound {
                    print(itemRestaurant.name)
                    print(itemRestaurant.placemark.title)
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.coordinate = itemRestaurant.placemark.coordinate
                        self.restaurantsMap.addAnnotation(newAnnotation)
                }
        }
    }
    ////////////////////////////////////////////////
    // alert controller of view controller        //
    ////////////////////////////////////////////////
    func errorGettingRestaurantsNearBy(with title:String, message:String, style:UIAlertControllerStyle)  {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: style)
        errorAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        DispatchQueue.main.async {
                self.navigationController?.present(errorAlert, animated: true, completion: nil)
        }
    }
    
}










