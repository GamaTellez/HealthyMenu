//
//  Extensions.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import MapKit

extension URLSession {
    func findRestaurantMenu(restaurantName: String, completion:@escaping (_ menu:[String:Any]?)-> Void) {
        let kNutrionixAppId = "f8baaf08"
        let kNutrionixApplicationKey = "3de37b0ec22fc6ebf375c8911b6938ba"
        let kNutrionixSearchEndPoint = "https://api.nutritionix.com/v1_1/search/" + restaurantName.replacingOccurrences(of: " ", with: "%") + "?results=0%3A50&cal_min=100&cal_max=50000&fields=item_name%2Cnf_calories%2Cnf_protein&appId=" + kNutrionixAppId + "&appKey=" + kNutrionixApplicationKey
        let session = URLSession.shared
        guard let urlForRequest:URL = URL(string: kNutrionixSearchEndPoint) else {
            completion(nil)
            return
        }
        let menuTask = session.dataTask(with: urlForRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                completion(nil)
                return
            }
            do {
                let menuJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                completion(menuJson)
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        menuTask.resume()
    }
}


