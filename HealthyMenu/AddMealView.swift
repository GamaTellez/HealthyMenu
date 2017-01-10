//
//  AddMealView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/30/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

protocol AddNewMealViewProtocol {
    //func newMealCreated(newMeal:Meal)
}

class AddMealView: UIView , UITextFieldDelegate {
    private var selectedColor = UIColor.blue
    private var nonSelectedColor = UIColor.white
    private var proteinLabel:CounterLabel!
    private var titleLabel:UILabel!
    private var nameTextField:UITextField!
    private var caloriesLabel:CounterLabel!
    private var slider:UISlider!
    private var saveButton:UIButton!
    private var closeButton:UIButton!
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x + 10, y: frame.height, width: frame.width - 20, height: frame.height / 2))
        self.setUpTitleLabel()
        self.setUpnameTextField()
        self.setUpProteinLabel()
        self.setUpCaloriesLabel()
        self.setUpSlider()
        self.setUpSaveButton()
        self.setUpCloseButton()
               self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /************************************************
    * title Label Set up
    *************************************************/
    private func setUpTitleLabel() {
        self.titleLabel = UILabel(frame: CGRect(x: 3, y: 20, width: self.frame.width - 20, height:30))
        self.titleLabel.text = "Add Meal"
        self.titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
    }
    
    /************************************************
     * text field set up
     *************************************************/
    private func setUpnameTextField() {
        self.nameTextField = UITextField(frame: CGRect(x: 5, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 5, width: self.frame.width - 10, height: 30))
        self.nameTextField.borderStyle = .roundedRect
        self.nameTextField.delegate = self
        self.nameTextField.returnKeyType = UIReturnKeyType.done
        self.addSubview(nameTextField)
    }
    
    /************************************************
     * proteinBUttonLabel
     *************************************************/
    private func setUpProteinLabel() {
        self.proteinLabel = CounterLabel(frame:CGRect(x: 40, y: nameTextField.frame.origin.y + self.nameTextField.frame.height + 10, width: self.frame.width / 3, height: self.frame.width / 3), function:#selector(self.setProteinLabelSelected), andView:self)
        self.proteinLabel.backgroundColor = self.nonSelectedColor
        self.addSubview(self.proteinLabel)
    }
    
    /************************************************
     * calories button label
     *************************************************/
    private func setUpCaloriesLabel() {
        self.caloriesLabel = CounterLabel(frame: CGRect(x: self.proteinLabel.frame.width + 80, y: self.nameTextField.frame.origin.y + self.nameTextField.frame.height + 10, width: self.frame.width / 3, height: self.frame.width / 3), function: #selector(self.setCaloriesLabelSelected), andView:self)
        self.caloriesLabel.backgroundColor = self.nonSelectedColor
        self.addSubview(self.caloriesLabel)
    }
    
    /************************************************
     * slider det up
     *************************************************/
    private func setUpSlider() {
        self.slider = UISlider(frame: CGRect(x: 5, y: self.caloriesLabel.frame.origin.y + self.caloriesLabel.frame.height + 15, width: self.frame.width - 10, height: 20))
        self.slider.addTarget(self, action: #selector(self.updateCounts(slider:)), for: UIControlEvents.allEvents)
        self.addSubview(self.slider)
        self.slider.isEnabled = false
    }
    
    /************************************************
     * save button set up
     *************************************************/
    private func setUpSaveButton() {
        self.saveButton = UIButton(frame: CGRect(x: 10, y: self.slider.frame.origin.y + self.slider.frame.height + 25, width: self.frame.width - 20, height: 30))
        self.saveButton.isEnabled = false
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.layer.borderWidth = 1
        self.saveButton.layer.cornerRadius = 4
        self.saveButton.layer.borderColor = UIColor.black.cgColor
        self.saveButton.setTitleColor(UIColor.black, for: .normal)
        self.saveButton.addTarget(self, action: #selector(self.saveNewMeal), for: .allEvents)
        self.addSubview(saveButton)
    }
    
    /************************************************
     * closeButtonSetUp
     *************************************************/
    private func setUpCloseButton() {
        self.closeButton = UIButton(frame: CGRect(x: -10, y: -10, width: 20, height: 20))
        self.closeButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
        self.addSubview(self.closeButton)
    }
    
    internal func present() {
        UIView.animate(withDuration: 0.4, animations: {
            self.center = self.superview!.center
        }, completion: {(finished:Bool) in
            
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.center.y -= self.superview!.frame.height
        }, completion: { (finished:Bool) in
            self.removeFromSuperview()
        })
    }
    
    /****************************************************
    * updates label that is selected,
    * it will update de value of the label that is selected (blue background)
    *****************************************************/
    @objc private func updateCounts(slider:UISlider) {
        if self.proteinLabel.backgroundColor == UIColor.blue {
            self.proteinLabel.value = Int(slider.value)
        }
        if self.caloriesLabel.backgroundColor == UIColor.blue {
            self.caloriesLabel.value = Int(slider.value)
        }
        self.checkToEnableSaveButton()
    }
    
    
    /*****************************************************
     * uitextfield delegate methods
     ******************************************************/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    /*****************************************************
    *
    ******************************************************/
    @objc private func setProteinLabelSelected() {
        if (self.nameTextField.isEditing)  {
            self.nameTextField.resignFirstResponder()
        }
        if (!self.slider.isEnabled) {
            self.slider.isEnabled = true
        }
        self.proteinLabel.backgroundColor = self.selectedColor
        self.caloriesLabel.backgroundColor = self.nonSelectedColor
        self.titleLabel.text = "Set Protein"
        self.slider.maximumValue = 400
        self.slider.setValue(Float(self.proteinLabel.value), animated: true)
        self.checkToEnableSaveButton()
    }
    
    /*****************************************************
     *
     ******************************************************/
    @objc private func setCaloriesLabelSelected() {
        if (self.nameTextField.isEditing) {
            self.nameTextField.resignFirstResponder()
        }
        if (!self.slider.isEnabled) {
                self.slider.isEnabled = true
            }
        self.caloriesLabel.backgroundColor = self.selectedColor
        self.proteinLabel.backgroundColor = self.nonSelectedColor
        self.titleLabel.text = "Set Calories"
        self.slider.maximumValue = 3000
        self.slider.setValue(Float(self.caloriesLabel.value), animated: true)
        self.checkToEnableSaveButton()
    }
    
    /*****************************************************
     *check if all requirements for meal have been added
     ******************************************************/
    private func checkToEnableSaveButton() {
        if self.nameTextField.text == "" || self.proteinLabel.value == 0 || self.caloriesLabel.value == 0 {
            self.saveButton.isEnabled = false
        }
        else {
        self.saveButton.isEnabled = true
            }
        }
    
    /*****************************************************
     *it saves the new meal when all information needed is 
     * provided
     ******************************************************/
    @objc private func saveNewMeal() {
        print("save meal")
    }
}
