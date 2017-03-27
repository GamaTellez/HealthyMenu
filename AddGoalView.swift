//
//  AddGoalView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/15/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

protocol NewGoalCreatedDelegate {
    func newGoalCreated(with proteinGoal:Int16, isCurrent:Bool)
}

class AddGoalView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var proteinGoalLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var proteinSlider: UISlider!
    var delegate:NewGoalCreatedDelegate?


    override init(frame: CGRect) {
        super.init(frame:CGRect(x: frame.origin.x + 10, y: frame.height, width: frame.width - 20, height: frame.height / 3))
            self.addSubview(self.instanceFromNib())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpViews()
    }
    private func setUpViews() {
        self.proteinSlider.maximumValue = 400
        self.proteinSlider.minimumValue = 100
        self.proteinSlider.tintColor = UIColor(red: 0.310, green: 0.808, blue: 0.851, alpha: 1.00)
        self.proteinSlider.setValue(self.proteinSlider.minimumValue, animated: true)
        self.proteinGoalLabel.text = "100"
        self.proteinGoalLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 50)
        self.proteinGoalLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        self.titleLabel.text = "Add New Goal"
        self.titleLabel.textColor = UIColor.white
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.sizeToFit()
        self.saveButton.setImage(UIImage(named:"saveIcon"), for: .normal)
        self.alpha = 0.9
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.black
    }
    
    @IBAction func proteinSliderValueChanged(_ sender: UISlider) {
        self.proteinGoalLabel.text = String(format:"%d", Int(sender.value))
    }
    

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let delegate = self.delegate else {
            self.dismiss()
            return
        }
        delegate.newGoalCreated(with: Int16(self.proteinSlider.value), isCurrent: true)
        self.dismiss()
    }
  
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss()
    }
    
    private func instanceFromNib() -> AddGoalView {
        return UINib(nibName: "AddGoalView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AddGoalView
    }

    internal func present(to point:CGPoint) {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = point
        }, completion: {(finished:Bool) in
        })
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y += self.superview!.frame.height
            self.alpha = 0
        }, completion: { (finished:Bool) in
            self.removeFromSuperview()
        })
    }
}
