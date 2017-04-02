//
//  Extensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import Gecco

extension URLSession {
    func performNutrionixSearch(textToSearch: String, completion:@escaping (_ results:[NSDictionary]?)-> Void) {
        let kNutrionixAppId = "f8baaf08"
        let kNutrionixApplicationKey = "3de37b0ec22fc6ebf375c8911b6938ba"
        let kNutrionixSearchEndPoint = "https://api.nutritionix.com/v1_1/search/" + textToSearch.replacingOccurrences(of: " ", with: "%") + "?results=0%3A50&cal_min=100&cal_max=50000&fields=item_name%2Cbrand_name%2Cnf_calories%2Cnf_protein&appId=" + kNutrionixAppId + "&appKey=" + kNutrionixApplicationKey
        guard let urlForRequest:URL = URL(string: kNutrionixSearchEndPoint) else {
            completion(nil)
            return
        }
        let menuTask = URLSession.shared.dataTask(with: urlForRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                completion(nil)
                return
            }
            do {
                let menuJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                //print(menuJson)
                guard let resultsArray = menuJson["hits"] as? [NSDictionary] else {
                    completion(nil)
                    return
                }
                completion(resultsArray)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        menuTask.resume()
    }
}

extension NSDate {
    func readableDate()-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self as Date)
    }
}

extension UINavigationController {
    func addStatusBarView() {
        let statusBarView = UIView(frame: CGRect(x: 0, y: -20, width: self.view.frame.width, height: 22))
        statusBarView.backgroundColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
        self.navigationBar.addSubview(statusBarView)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func getRootViewController()-> UIViewController {
            return self.viewControllers.first!
        }
}

extension UIViewController {
    func setAppBackGroundColor() {
        self.view.backgroundColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.00)
    }
}

extension UIButton {
    func setAppFormatTitle(text:String, buttonState:UIControlState) {
        guard let fontForButton = UIFont(name:"HelveticaNeue-CondensedBold", size: 25) else { return }
        let attributedString = NSAttributedString(string: text, attributes:[NSFontAttributeName:fontForButton, NSForegroundColorAttributeName:UIColor.white])
        self.setAttributedTitle(attributedString, for: buttonState)
    }
}





















