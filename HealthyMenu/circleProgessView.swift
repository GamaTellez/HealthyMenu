//
//  circleProgessView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/21/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class circleProgessView: UIView {
    let circlePathLayer = CAShapeLayer()
    let circleRadius:CGFloat = 20.0

    override init(frame:CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circlePathLayer.frame = self.bounds
        circlePathLayer.path = self.pathForCircle().cgPath
    }
    
    private func setUp() {
        self.circlePathLayer.frame = self.bounds
        self.circlePathLayer.lineWidth = 2
        self.circlePathLayer.fillColor = UIColor.blue.cgColor
        self.circlePathLayer.strokeColor = UIColor.red.cgColor
        self.layer.addSublayer(self.circlePathLayer)
        self.backgroundColor = UIColor.white
    }
    
    private func calcCircleFrame() -> CGRect {
        var frameForCircle = CGRect(x: 0, y: 0, width: 2 * self.circleRadius, height: 2 * self.circleRadius)
        frameForCircle.origin.x = circlePathLayer.bounds.midX - frameForCircle.midX
        frameForCircle.origin.y = circlePathLayer.bounds.midY - frameForCircle.midY
        return frameForCircle
    }
    
    private func pathForCircle() -> UIBezierPath {
        return UIBezierPath(ovalIn: self.calcCircleFrame())
    }
}
