//
//  CircledLabel.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/22/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable class CircledLabel: UILabel {
   
    private let kStartingAndEndAngle = -90.0
    private var strokeColor:UIColor = UIColor.black
    private var strokeWidth:CGFloat = 8.0
    internal var caloriesToDisplay:Int = 0 {
            didSet {
                self.text = String(format: "%d", self.caloriesToDisplay)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.strokeWidth > 0.0 {
            let radious = max(self.bounds.width, self.bounds.height) / 2.5
            let strokePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX,y: self.bounds.midY),
                                          radius: radious,
                                          startAngle:CGFloat(self.degreesToRadians(0)),
                                          endAngle:CGFloat(self.degreesToRadians(360)),
                                          clockwise: true)
            strokePath.lineWidth = self.strokeWidth
            strokeColor.setStroke()
            strokePath.stroke()
        }
    }
    
    func degreesToRadians (_ value:Double) -> Double {
        return value * Double(M_PI) / 180.0
    }
    
    func radiansToDegrees (_ value:Double) -> Double {
        return value * 180.0 / Double(M_PI)
    }
    
    internal func update() {
        guard let currentCalorieCount = NSFetchRequest<NSFetchRequestResult>.getCurrentGoal()?.getCurrentyDay()?.caloriesCount else {
            return
        }
        self.caloriesToDisplay = Int(currentCalorieCount)
    }
}
