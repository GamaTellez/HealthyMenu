//
//  AddGoalView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/15/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class AddGoalView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var proteinGoalLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var proteinSlider: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: frame.origin.x + 10, y: frame.height, width: frame.width - 20, height: frame.height / 3))
        self.addSubview(self.instanceFromNib())
    }
    
    @IBAction func proteinSliderValueChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func saveBurronTapped(_ sender: UIButton) {
    
    }
  
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
    }
    
    private func instanceFromNib() -> UIView {
        return UINib(nibName: "AddGoalView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
}
