//
//  GoalDaysCircularChart.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/7/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

@IBDesignable class GoalDaysCircularChart: UILabel {
    
    private let kStartingAngle = -90.0
    internal var totalOfDays:Double = 0
    internal var daysGoalWasReached:Double = 0
    @IBInspectable var baseStrokeColor:UIColor = UIColor.gray
    @IBInspectable var baseStrokeWidth:CGFloat = 30
    var daysStrokeColor:UIColor = UIColor.black
    var daysStrokeWidth:CGFloat = 20
    var daysFilled:Double = 0.0 {
        didSet {
            if self.daysFilled < 0.0  { self.daysFilled = 0.0 }
            if self.daysFilled > Double(self.totalOfDays) { self.daysFilled = Double(self.totalOfDays) }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawBasePath()
        self.drawDaysPath()
    }
    
    private func drawBasePath() {
        let radiusForBase = max(self.bounds.width, self.bounds.height) / 2.5
        let baseStrokePath = UIBezierPath(arcCenter: CGPoint(x:self.bounds.midX, y: self.bounds.midY),
                                          radius: radiusForBase,
                                          startAngle: CGFloat(degreesToRadians(self.kStartingAngle)),
                                          endAngle: CGFloat(degreesToRadians(360)),
                                          clockwise: true)
        baseStrokePath.lineWidth = self.baseStrokeWidth
        self.baseStrokeColor.setStroke()
        baseStrokePath.stroke()
    }
    
    
    private func drawDaysPath() {
        let radiusForDays = max(self.bounds.width, self.bounds.height) / 2.5
        let daysStrokePath = UIBezierPath(arcCenter: CGPoint(x:self.bounds.midX, y: self.bounds.midY),
                                          radius: radiusForDays,
                                          startAngle: CGFloat(self.degreesToRadians(self.kStartingAngle)),
                                          endAngle: CGFloat(self.degreesToRadians(self.kStartingAngle + 360 * (self.daysFilled / self.totalOfDays))),
                                          clockwise: true)
        daysStrokePath.lineWidth = self.daysStrokeWidth
        self.daysStrokeColor.setStroke()
        daysStrokePath.stroke()
    }
    
    internal func animateToDay() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            self.daysFilled += 1
            if self.daysFilled == self.daysGoalWasReached {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    
    func degreesToRadians (_ value:Double) -> Double {
        return value * Double(M_PI) / 180.0
    }
    
    func radiansToDegrees (_ value:Double) -> Double {
        return value * 180.0 / Double(M_PI)
    }

}
