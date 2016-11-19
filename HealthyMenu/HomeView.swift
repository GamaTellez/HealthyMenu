//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet var restaurantsTableView: UITableView!
    var restaurantsTableDS = RestaurantsDataSource()
    private var restaurauntsFound:[Restaurant] = []
    var locationManager = CLLocationManager()
    var userLocation:CLLocation?
    let kFisrtInstall = "firstInstall"
    let kToRestaurantMeny = "toRestaurantMenu"
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
        self.restaurantsTableView.delegate = self
        self.restaurantsTableView.dataSource = self.restaurantsTableDS
        //location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100
        //search request
        self.restaurantsRequest.naturalLanguageQuery = "Fast Food"
        
    }

    ///////////////////////////////////////////
    //location manager authorization request //
    //present an alert controller depending  //
    //with custom message depending on the   //
    // user response to the request          //
    ///////////////////////////////////////////
    
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
        }
    }
    
    ///////////////////////////////////////////////////////
    // obtaining user location and setting up the region //
    // for the local search request                      //
    ///////////////////////////////////////////////////////
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.userLocation = locations.last
            let span = MKCoordinateSpan(latitudeDelta: (self.userLocation?.coordinate.latitude)!, longitudeDelta: (self.userLocation?.coordinate.longitude)!)
            self.restaurantsRequest.region = MKCoordinateRegion(center: (self.userLocation?.coordinate)!, span: span)
            self.findRestaurantsNearuser()
    }
    
    /***********************************************************
     * localsearch for fast food restaurants, it presents a    *
     * an alert controller if there was an error in the search *
     * or no restaurants were found                            *
     ***********************************************************/
    
    func findRestaurantsNearuser() {
            let restaurantsSearch = MKLocalSearch(request: self.restaurantsRequest)
            restaurantsSearch.start { (localSearchResponse, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
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
                if (!self.restaurauntsFound.isEmpty) {
                    self.restaurauntsFound.removeAll()
                }
                for restaurantItem in restaurantsFound {
                    self.restaurauntsFound.append(Restaurant(name: restaurantItem.name, address: restaurantItem.placemark.thoroughfare, location: restaurantItem.placemark.location, userLocation: self.userLocation))
                }
                self.restaurantsTableDS.updateRestaurantsDataSource(restaurantsFound: self.restaurauntsFound)
                    DispatchQueue.main.async {
                        self.restaurantsTableView.reloadData()
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
    
    /************************************************
     *table view delegate methods                   *
     ************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /*************************************************
     * setting up for segue                           *
    **************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantMenu" {
            if let destinationVC = segue.destination as? RestaurantMenuVC {
                guard let rowSelected = self.restaurantsTableView.indexPathForSelectedRow?.row else {
                return
            }
                let restaurantSelected = self.restaurauntsFound[rowSelected]
                destinationVC.restaurantSelected = restaurantSelected
            }
        }
    
    }
}










