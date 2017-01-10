//
//  CounterLabel.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 12/17/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class CounterLabel: UILabel {
    var value:Int = 0 {
        willSet {
            self.willChangeValue(forKey: "value updated")
        }
        didSet {
            self.didChangeValue(forKey: "value updated")
            self.displayValue()
        }
    }
    
    internal func displayValue() {
        self.text = String(format:"%d", self.value)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, function:Selector, andView:UIView) {
        self.init(frame:frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: andView, action: function))
        self.text = "0"
        self.clipsToBounds = true
        self.textAlignment = .center
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.font = UIFont(name: "AmericanTypewriter", size: 30)
        self.isUserInteractionEnabled = true
    }
    
    private func setUp() {
        
    }
    
    
}
