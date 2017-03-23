//
//  ResetDayView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 2/8/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

protocol NewDayDelegate {
    func newDayAdded(date:NSDate)
}

class ResetDayView: UIView {
    var delegate:NewDayDelegate?
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var resetButton: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame:CGRect, distanceFromTop:CGFloat) {
        self.init()
        self.frame =  CGRect(x: frame.origin.x,
                             y: distanceFromTop,
                             width: frame.width,
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
        self.setUpButtons()
        self.setUpLabels()
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.black
        self.alpha = 0.9
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.remove(newDayAdded:false)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
       self.remove(newDayAdded: true)
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
                if (newDayAdded) {
                guard let delegate = self.delegate else {
                    return
                }
                delegate.newDayAdded(date: NSDate())
                }
            }
        }
    }

    private func setUpButtons() {
        self.cancelButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.cancelButton.sizeToFit()
    }
    
    private func setUpLabels() {
        self.titleLabel.text = "New Day?"
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 25)
        self.messageLabel.text = "Starting a new day will reset your protein count to 0, do you want to continue?"
        self.messageLabel.textColor = UIColor.white
        self.messageLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size: 15)
        self.messageLabel.backgroundColor = UIColor.clear
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
    }
    
}
