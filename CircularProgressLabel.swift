//
//  CircularProgressLabel.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 11/28/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable class CircularProgressLabel: UILabel {

    private var timer: Timer!
    private let kStartingAngle = -90.0
    internal var proteinGoal:Double = 0
    internal var proteinCount:Double = 0
    @IBInspectable var strokeColor:UIColor = UIColor.black
    @IBInspectable var strokeWidth:CGFloat = 20.0
    @IBInspectable var completed:Double = 0 {
        willSet { self.willChangeValue(forKey: "completed") }
        didSet {
            if completed < 0.0 { completed = 0.0 }
            if completed > self.proteinGoal { completed = self.proteinGoal }
            self.didChangeValue(forKey: "completed")
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.strokeWidth > 0.0 {
            let radious = max(self.bounds.width, self.bounds.height) / 2.5
            let strokePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX,y: self.bounds.midY),
                                          radius: radious,
                                          startAngle:CGFloat(degreesToRadians(self.kStartingAngle)),
                                          endAngle:CGFloat(degreesToRadians(self.kStartingAngle + 360 * (self.completed / self.proteinGoal))),
                                          clockwise: true)
            strokePath.lineWidth = self.strokeWidth
            strokeColor.setStroke()
            strokePath.stroke()
        }
    }
    
    internal func update() {
                guard let currentGoal = NSFetchRequest<NSFetchRequestResult>.getCurrentGoal() else { return }
                guard let currentCountInDay = currentGoal.getCurrentyDay()?.proteinCount else { return }
                self.animateLabel(proteinCount: Double(currentCountInDay), proteinGoal: Double(currentGoal.proteinGoal))
    }

    private func animateLabel(proteinCount:Double, proteinGoal:Double) {
        self.proteinGoal = proteinGoal
        self.proteinCount = proteinCount
        self.text = String(format: "%.0f / %.0f", proteinCount, proteinGoal)
        if (self.proteinCount != 0) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.completed += 1
                self.text = String(format: "%.0f / %.0f", self.completed, proteinGoal)
                if (self.completed == self.proteinCount) {
                    self.timer.invalidate()
                }
            })
        }
        if (self.completed > self.proteinCount) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
                self.completed -= 1
                self.text = String(format: "%.0f / %.0f", self.completed, proteinGoal)
                if (self.completed == self.proteinCount) {
                    self.timer.invalidate()
                }
            })
        }
    }
    
    func degreesToRadians (_ value:Double) -> Double {
        return value * Double(M_PI) / 180.0
    }
    
    func radiansToDegrees (_ value:Double) -> Double {
        return value * 180.0 / Double(M_PI)
    }
    
    
    
}

