//
//  ResetDayView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/8/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class ResetDayView: UIView {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, distanceFromTop:CGFloat, resetDaySelector:Selector, viewController:UIViewController, enableViewButtons:Selector) {
        self.init()
        self.frame =  CGRect(x: 5,
                             y: distanceFromTop + 10,
                             width: frame.width - 10,
                             height: frame.height / 3)
        let infoLabel = self.createInfoLabel(from: self.frame)
        self.addSubview(infoLabel)
        let resetButton = self.createResetDayButton(from: infoLabel.frame)
        self.addSubview(resetButton)
        resetButton.addTarget(viewController, action: resetDaySelector, for: .touchUpInside)
        let cancelButton = self.createCancelButton(from: resetButton.frame)
        cancelButton.addTarget(viewController, action: enableViewButtons, for: .touchUpInside)
        self.addSubview(cancelButton)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createInfoLabel(from frame:CGRect) -> UILabel {
        let infoLabel = UILabel(frame: CGRect(x: 5,
                                              y: 10,
                                              width: frame.width - 10,
                                              height: frame.height / 3))
        infoLabel.text = "Are you sure you want to re start the day? doing so will also set your protein count to 0"
        infoLabel.numberOfLines = 0
        return infoLabel
    }
    
    private func createResetDayButton(from frame:CGRect)-> UIButton {
        let resetButton = UIButton(frame: CGRect(x: 10,
                                                 y: frame.origin.y + frame.height + 10,
                                                 width: self.frame.width - 20,
                                                 height: self.frame.height / 4))
        resetButton.setTitle("Add New Day", for: .normal)
        return resetButton
    }
    
    private func createCancelButton(from frame:CGRect)-> UIButton {
        let cancelButton = UIButton(frame: CGRect(x: 10,
                                                  y: frame.origin.y + frame.height + 10,
                                                  width: self.frame.width - 20,
                                                  height: self.frame.height / 4))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
        return cancelButton
    }
    
    internal func show() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }
    }
    
    @objc private func remove() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
        }) { (finished) in
            if (finished) {
                self.removeFromSuperview()
            }
        }
    }

}
