//
//  AddProteinOptionsView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/28/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//
import UIKit

/***********************************************************
 * addNewMealProtocol
 ***********************************************************/
//    protocol OptionsToAddMealDelegate {
//        func buttonTapped(name:String)
//    }

class AddProteinOptionsView: UIView {
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, viewController:UIViewController, searchMealSelector:Selector, enterManuallySelector:Selector) {
        self.init()
        self.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height / 3)
        self.backgroundColor = UIColor.white
        let enterManuallyButton = UIButton(frame: CGRect(x: 0 , y: 0, width: frame.width, height: self.frame.height / 3))
        enterManuallyButton.setTitle("Enter Meal Manually", for: .normal)
        enterManuallyButton.backgroundColor = UIColor.black
        enterManuallyButton.addTarget(viewController, action: enterManuallySelector, for: .touchUpInside)
        enterManuallyButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        self.addSubview(enterManuallyButton)
        let searchMealButton = UIButton(frame: CGRect(x: 0, y: enterManuallyButton.frame.height, width: frame.width, height: self.frame.height / 3))
        searchMealButton.backgroundColor = UIColor.black
        searchMealButton.setTitle("Search Meal", for: .normal)
        searchMealButton.addTarget(viewController, action: searchMealSelector, for: .touchUpInside)
        searchMealButton.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        self.addSubview(searchMealButton)
        let cancelButton = UIButton(frame: CGRect(x: 0, y: enterManuallyButton.frame.height + searchMealButton.frame.height, width: frame.width, height: self.frame.height / 3))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.black
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        self.addSubview(cancelButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    internal func cancelButtonTapped() {
        self.dismissView()
    }
    
    internal func presentView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            self.center.y = self.center.y - self.frame.height
        }, completion: {(finished) in
        })
    }
    
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y = self.center.y + self.frame.height
        }, completion: { (succed:Bool) in
            self.removeFromSuperview()

        })
    }
}

