//
//  AppearanceManager.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/20/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import Foundation
import UIKit

class AppAppearance : NSObject {
    
    static func setAppApperance() {
        let navBarBlackBackgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.125, alpha: 1.00)
        let navBarGreenTintColor = UIColor(red: 0.192, green: 0.518, blue: 0.118, alpha: 1.00)
        
        UINavigationBar.appearance().barTintColor = navBarBlackBackgroundColor
        UINavigationBar.appearance().tintColor = navBarGreenTintColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:navBarGreenTintColor], for: UIControlState.normal)
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.white
        //Mark:label apperance set in their views
    }
}
