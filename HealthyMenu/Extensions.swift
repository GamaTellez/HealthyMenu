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

extension NSEntityDescription {
    func createEntityDay() -> NSEntityDescription? {
        guard let dayEntity = NSEntityDescription.entity(forEntityName: "Day", in: PersistantStorageCoordinator().context) else {
            return nil
        }
        return dayEntity
    }
}

extension NSManagedObject {
    func createDay(dayEntity:NSEntityDescription)-> Day {
        return NSManagedObject(entity: dayEntity, insertInto: PersistantStorageCoordinator().context) as! Day
    }
}


extension NSFetchRequest {
    func getCurrentDay() {
        let daysFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let daysDescriptor = NSSortDescriptor(key: "date", ascending: true)
        daysFetchRequest.sortDescriptors = [daysDescriptor]
        do {
            let days = try PersistantStorageCoordinator().context.execute(daysFetchRequest) as! [Day]
                print(days)
        } catch  {
            print(error.localizedDescription)
        }
    }
}







