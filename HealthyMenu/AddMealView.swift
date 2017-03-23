//
//  AddMealView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/30/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

protocol NewMealCreatedDelegate {
    func newMealCreated(protein:Int16, calories:Int16, name:String)
    func noMealWasCreated() 
}

class AddMealView: UIView , UITextFieldDelegate {
    @IBOutlet var titleViewLabel: UILabel!
    @IBOutlet var mealNameTextField: UITextField!
    @IBOutlet var proteinTitleLabel: UILabel!
    @IBOutlet var proteinSlider: UISlider!
    @IBOutlet var proteinCountLabel: UILabel!
    @IBOutlet var caloriesTitleLabel: UILabel!
    @IBOutlet var caloriesSlider: UISlider!
    @IBOutlet var caloriesCounterLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    public var delegate:NewMealCreatedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x + 10, y: frame.height, width: frame.width - 45, height: frame.height / 2))
        self.addSubview(self.instanceFromNib())
    }
    
    override func awakeFromNib() {
        self.setUpAppearance()
    }

    private func setUpAppearance() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.black
        self.alpha = 0.8
        self.proteinCountLabel.layer.cornerRadius = 40
        self.proteinCountLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 25)
        self.proteinCountLabel.textColor = UIColor(red: 0.251, green: 0.251, blue: 0.251, alpha: 1.00)
        self.proteinCountLabel.backgroundColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1.00)
        self.proteinCountLabel.alpha = 0.9
        self.caloriesCounterLabel.layer.cornerRadius = 40
        self.caloriesCounterLabel.alpha = 0.9
        self.caloriesCounterLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 25)
        self.caloriesCounterLabel.textColor = UIColor(red: 0.251, green: 0.251, blue: 0.251, alpha: 1.00)
        self.caloriesCounterLabel.backgroundColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1.00)
        self.proteinTitleLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 15)
        self.proteinTitleLabel.backgroundColor = UIColor.clear
        self.proteinTitleLabel.textColor = UIColor.white
        self.caloriesTitleLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 15)
        self.caloriesTitleLabel.backgroundColor = UIColor.clear
        self.caloriesTitleLabel.textColor = UIColor.white
        self.proteinSlider.maximumValue = 100
        self.proteinSlider.minimumValue = 0
        self.proteinSlider.setValue(0.0, animated: true)
        self.proteinSlider.tintColor = UIColor(red: 0.424, green: 0.682, blue: 0.702, alpha: 1.00)
        self.caloriesSlider.maximumValue = 1000
        self.caloriesSlider.minimumValue = 0
        self.caloriesSlider.setValue(0.0, animated: true)
        self.caloriesSlider.tintColor = UIColor(red: 0.424, green: 0.682, blue: 0.702, alpha: 1.00)
        self.titleViewLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.titleViewLabel.textColor = UIColor.white
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.sizeToFit()
        self.saveButton.isEnabled = false
        self.mealNameTextField.delegate = self
        self.mealNameTextField.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
 
    }
    
    private func instanceFromNib() -> AddMealView {
        return UINib(nibName: "AddMealView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AddMealView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let theDelegate = self.delegate else {
            self.dismiss()
            return
        }
        theDelegate.newMealCreated(protein: Int16(self.proteinSlider.value), calories: Int16(self.caloriesSlider.value), name: self.mealNameTextField.text!)
        self.dismiss()
    }
    
    @IBAction func proteinCounterValueChanged(_ sender: UISlider) {
        self.proteinCountLabel.text = String(format:"%.0f", sender.value)
        self.enableSaveButton()
    }
    
    @IBAction func caloriesCounterValueChanged(_ sender: UISlider) {
        self.caloriesCounterLabel.text = String(format:"%.0f", self.caloriesSlider.value)
        self.enableSaveButton()
    }

    internal func present(toPoint:CGPoint) {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = toPoint
        }, completion: {(finished:Bool) in
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y -= self.superview!.frame.height
        }, completion: { (finished:Bool) in
            if (self.delegate != nil) {
                self.delegate?.noMealWasCreated()
            }
            self.removeFromSuperview()
        })
    }
    
    /*****************************************************
     * textfield delegates
     ******************************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.enableSaveButton()
        return true
    }
    private func enableSaveButton() {
        if (self.mealNameTextField.text != "") {
            self.saveButton.isEnabled = true
        }
    }
    
}
