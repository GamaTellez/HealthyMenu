//
//  GeneralBackView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/19/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class GeneralBackView: UIView {
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            self.backgroundColor = UIColor.clear
            let blurrEffect = UIBlurEffect(style:UIBlurEffectStyle.dark)
            let blurrEffectView = UIVisualEffectView(effect: blurrEffect)
            blurrEffectView.frame = self.frame
            blurrEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurrEffectView)
        } else {
            self.backgroundColor = UIColor.black
        }
    }
}
