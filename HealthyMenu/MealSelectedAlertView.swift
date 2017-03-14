//
//  MealSelectedAlertView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/9/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MealSelectedAlertView: UIView{
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var closeButtonTapped: UIButton!
    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    var itemSelected:SearchResultItem?
    
    convenience init(frame: CGRect,itemSelected:SearchResultItem) {
        self.init()
        self.addSubview(self.instanceFromNib())
        self.itemSelected = itemSelected
    }
    
    override func awakeFromNib() {
        self.setUpViews()
        
    }
    
    private func setUpViews() {
        self.proteinLabel.layer.cornerRadius = self.proteinLabel.frame.width / 2
        self.proteinLabel.layer.borderColor = UIColor.black.cgColor
        self.proteinLabel.layer.borderWidth = 1
        self.caloriesLabel.layer.cornerRadius = self.proteinLabel.frame.width / 2
        self.caloriesLabel.layer.borderColor = UIColor.black.cgColor
        self.caloriesLabel.layer.borderWidth = 1
        
    }
    
    private func instanceFromNib()-> MealSelectedAlertView{
        return UINib(nibName: "MealSelectedAlertView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MealSelectedAlertView
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
    
    internal func show() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }
    }
    
    @objc private func remove(newDayAdded:Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
        }) { (finished) in
            if (finished) {
                self.removeFromSuperview()
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
    
}
