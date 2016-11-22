//
//  ActivityIndicatorView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init(frame:CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 10
        self.activityIndicator.center = self.center
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func start() {
        self.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    internal func stop() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.removeFromSuperview()
    }
}
