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
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 0.5
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
        self.proteinSlider.minimumValue = 0
        self.proteinSlider.setValue(0, animated: true)
        self.proteinGoalLabel.text = "0"
        self.saveButton.setTitle("S", for: .normal)
        self.titleLabel.text = "Add New Goal"
    }
    
    @IBAction func proteinSliderValueChanged(_ sender: UISlider) {
        self.proteinGoalLabel.text = String(format:"%d", Int(sender.value))
    }
    
    @IBAction func saveBurronTapped(_ sender: UIButton) {
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

    internal func present() {
        UIView.animate(withDuration: 0.3, animations: {
            self.center = self.superview!.center
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
