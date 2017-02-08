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
        let higherToLowerProteinButton = UIButton(frame: CGRect(x: 0 , y: 0, width: frame.width, height: self.frame.height / 3))
        higherToLowerProteinButton.setTitle("Enter Meal Manually", for: .normal)
        higherToLowerProteinButton.backgroundColor = UIColor.black
        higherToLowerProteinButton.addTarget(viewController, action: enterManuallySelector, for: .touchDown)
        self.addSubview(higherToLowerProteinButton)
        let lowerToHigherCaloriesButton = UIButton(frame: CGRect(x: 0, y: higherToLowerProteinButton.frame.height, width: frame.width, height: self.frame.height / 3))
        lowerToHigherCaloriesButton.backgroundColor = UIColor.black
        lowerToHigherCaloriesButton.setTitle("Search Meal", for: .normal)
        lowerToHigherCaloriesButton.addTarget(viewController, action: searchMealSelector, for: .touchDown)
        self.addSubview(lowerToHigherCaloriesButton)
        let cancelButton = UIButton(frame: CGRect(x: 0, y: higherToLowerProteinButton.frame.height + lowerToHigherCaloriesButton.frame.height, width: frame.width, height: self.frame.height / 3))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.black
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchDown)
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
    
    private func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y = self.center.y + self.frame.height
        }, completion: { (succed:Bool) in
            self.removeFromSuperview()
        })
    }
}

