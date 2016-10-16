//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController, UICollectionViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var restaurantsCollectionView: UICollectionView!
    var restaurantsCollectionDS = RestaurantsDataSource()
    private var restaurauntsFound:[Restaurant]?
    var locationManager = CLLocationManager()
    var userLocation:CLLocation?
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
        //tableView
        self.restaurantsCollectionView.delegate = self
        self.restaurantsCollectionView.dataSource = self.restaurantsCollectionDS
        //location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //search request
        self.restaurantsRequest.naturalLanguageQuery = "Restaurants"
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
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.userLocation = locations.last
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
                for restaurantItem in restaurantsFound {
                    let newRestaurant = Restaurant(name: restaurantItem.name, address: restaurantItem.placemark.thoroughfare, location: restaurantItem.placemark.location, userLocation: self.userLocation)
                    self.restaurauntsFound?.append(newRestaurant)
                }
               self.restaurantsCollectionDS.updateRestaurantsDataSource(restaurantsFound: self.restaurauntsFound)
                DispatchQueue.main.async {
                    self.restaurantsCollectionView.reloadData()
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










