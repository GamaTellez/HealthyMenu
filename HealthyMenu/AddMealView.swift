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
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.setUpTextField()
        self.setUpCancelButton()
        self.setUpSaveButton()
        self.setUpSliders()
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

    internal func present() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = self.superview!.center
        }, completion: {(finished:Bool) in
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y -= self.superview!.frame.height
        }, completion: { (finished:Bool) in
            self.removeFromSuperview()
        })
    }
    
    private func setUpCancelButton() {
        self.cancelButton.center = self.frame.origin
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.sizeToFit()
        self.cancelButton.backgroundColor = UIColor.clear
        self.cancelButton.tintColor = UIColor.black
    }
    
    private func setUpSaveButton() {
        self.saveButton.isEnabled = false
    }
    
    
    private func setUpTextField() {
        self.mealNameTextField.delegate = self
    }
    
    private func setUpSliders() {
        self.proteinSlider.maximumValue = 100
        self.proteinSlider.minimumValue = 0
        self.proteinSlider.setValue(0.0, animated: true)
        self.caloriesSlider.maximumValue = 1000
        self.caloriesSlider.minimumValue = 0
        self.caloriesSlider.setValue(0.0, animated: true)
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
