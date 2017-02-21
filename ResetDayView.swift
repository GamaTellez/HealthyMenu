//
//  ResetDayView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/8/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class ResetDayView: UIView {
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var resetButton: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame:CGRect, distanceFromTop:CGFloat, resetDaySelector:Selector, viewController:UIViewController, enableViewButtons:Selector) {
        self.init()
        self.frame =  CGRect(x: 5,
                             y: distanceFromTop + 10,
                             width: frame.width - 20,
                             height: frame.height / 3)
        self.addSubview(self.instanceFromNib())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func instanceFromNib() -> ResetDayView {
        return UINib(nibName: "ResetDayView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ResetDayView
    }
    
    override func awakeFromNib() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        self.setUpButtons()
        self.setUpLabels()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.remove()
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.remove()
    }
    
    internal func show() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }
    }
    
    @objc private func remove() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
        }) { (finished) in
            if (finished) {
                self.removeFromSuperview()
            }
        }
    }

    private func setUpButtons() {
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.sizeToFit()
    }
    
    private func setUpLabels() {
        self.titleLabel.text = "New Day?"
        self.messageLabel.text = "Starting a new day will reset your protein count to 0, do you want to continue"
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
    }
    
}
