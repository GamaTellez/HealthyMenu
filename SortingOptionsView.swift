//
//  SortingOptionsView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/18/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

    /************************************************************
    * sorting protocol
    * it takes an array of menuitems and sorted them accordingly
    *************************************************************/
    protocol SortingViewDelegate {
        func sortedArray(sortedItems:[SearchResultItem])
    }

class SortingOptionsView: UIView {
    
    var delegate: SortingViewDelegate?
    internal var searchItemsArray:[SearchResultItem]?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height / 3))
        self.backgroundColor = UIColor.white
        let higherToLowerProteinButton = UIButton(frame: CGRect(x: 0 , y: 0, width: frame.width, height: self.frame.height / 3))
        higherToLowerProteinButton.setTitle("Protein High to Low", for: .normal)
        higherToLowerProteinButton.backgroundColor = UIColor.black
        higherToLowerProteinButton.addTarget(self, action: #selector(sortingByProteinButtonTapped), for: .touchDown)
        self.addSubview(higherToLowerProteinButton)
        let lowerToHigherCaloriesButton = UIButton(frame: CGRect(x: 0, y: higherToLowerProteinButton.frame.height, width: frame.width, height: self.frame.height / 3))
        lowerToHigherCaloriesButton.backgroundColor = UIColor.black
        lowerToHigherCaloriesButton.setTitle("Calories Low To High", for: .normal)
        lowerToHigherCaloriesButton.addTarget(self, action: #selector(sortingByCaloriesButtonTapped), for: .touchDown)
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
    
    internal func sortingByProteinButtonTapped() {
        self.dismissView()
        self.searchItemsArray?.sort(by: {$0.itemProtein! > $1.itemProtein!})
        self.delegate?.sortedArray(sortedItems: self.searchItemsArray!)
    }
    
    internal func sortingByCaloriesButtonTapped() {
        self.dismissView()
        self.searchItemsArray?.sort(by: {$0.itemCalories! < $1.itemCalories!})
        self.delegate?.sortedArray(sortedItems: self.searchItemsArray!)
    }
    
    internal func cancelButtonTapped() {
        self.dismissView()
    }
    
    internal func presentView() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
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
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
