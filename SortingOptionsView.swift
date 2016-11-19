//
//  SortingOptionsView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/18/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class SortingOptionsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height / 3))
        self.backgroundColor = UIColor.white
        let higherToLowerProteinButton = UIButton(frame: CGRect(x: 0 , y: 0, width: frame.width, height: self.frame.height / 2))
        higherToLowerProteinButton.setTitle("Protein High to Low", for: .normal)
        higherToLowerProteinButton.backgroundColor = UIColor.black
        higherToLowerProteinButton.addTarget(self, action: #selector(sortingByProteinButtonTapped), for: .touchDown)
        self.addSubview(higherToLowerProteinButton)
        let lowerToHigherCaloriesButton = UIButton(frame: CGRect(x: 0, y: higherToLowerProteinButton.frame.height, width: frame.width, height: self.frame.height / 2))
        lowerToHigherCaloriesButton.backgroundColor = UIColor.black
        lowerToHigherCaloriesButton.setTitle("Calories Low To High", for: .normal)
        lowerToHigherCaloriesButton.addTarget(self, action: #selector(sortingByCaloriesButtonTapped), for: .touchDown)
        self.addSubview(lowerToHigherCaloriesButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func sortingByProteinButtonTapped() {
        self.dismissView()
    }
    
    internal func sortingByCaloriesButtonTapped() {
        self.dismissView()
    }
    
    internal func presentView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.center.y = self.center.y - self.frame.height
        })
    }

    private func dismissView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.center.x = self.center.y + self.frame.height
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
