//
//  GoalDaysCircularChart.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/7/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

@IBDesignable class GoalDaysCircularChart: UILabel, CAAnimationDelegate {
    
    private let kStartingAngle = -90.0
    private var totalOfDays:Double = 0
    private var daysGoalWasReached:Double = 0
    @IBInspectable var baseStrokeColor:UIColor = UIColor.gray
    @IBInspectable var baseStrokeWidth:CGFloat = 30
    var daysStrokeColor:UIColor = UIColor.black
    var daysStrokeWidth:CGFloat = 20
    var labelLineWidth:CGFloat = 1.0
    var labelLineColor:UIColor = UIColor.blue
    var daysPath:UIBezierPath?
    var daysLabel:UILabel = UILabel()
    
    var daysFilled:Double = 0.0 {
        didSet {
//            if self.daysFilled < 0.0  {
//                self.daysFilled = 0.0
//            }
//            if self.daysFilled > Double(self.totalOfDays) {
//                self.daysFilled = Double(self.totalOfDays)
//            }
                self.setNeedsDisplay()
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
        self.daysPath = UIBezierPath(arcCenter: CGPoint(x:self.bounds.midX, y: self.bounds.midY),
                                          radius: radiusForDays,
                                          startAngle: CGFloat(self.degreesToRadians(self.kStartingAngle)),
                                          endAngle: CGFloat(self.degreesToRadians(self.kStartingAngle + 360 * (self.daysFilled / self.totalOfDays))),
                                          clockwise: true)
        self.daysPath?.lineWidth = self.daysStrokeWidth
        self.daysStrokeColor.setStroke()
        self.daysPath?.stroke()
    }
    
    internal func animate(totalDays:Double, totalDaysGoalWasReached:Double) {
        self.daysFilled = 0
        self.totalOfDays = totalDays
        self.daysGoalWasReached = totalDaysGoalWasReached
        self.text = String(format:"%.0f days \n with goal", self.totalOfDays)
        self.layer.sublayers = nil
        if (self.daysGoalWasReached == 0 ) {
            print("nothing happens, except updating label days")
        } else {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
                    self.daysFilled += 1
                if (self.daysFilled == self.daysGoalWasReached) {
                    timer.invalidate()
                    //self.addDayLabel(referencePoint: (self.daysPath?.currentPoint)!, valueForLabel:   Int(self.daysFilled))
                }
            })
            timer.fire()
        }
    }
    
    private func addDayLabel(referencePoint:CGPoint, valueForLabel:Int) {
        var xInclineLine = referencePoint.x
        var yInclineLine = referencePoint.y
        
        if (xInclineLine > self.center.x) {
            xInclineLine += 40
            yInclineLine -= 20
        } else if (xInclineLine < self.center.x) {
            xInclineLine -= 40
            yInclineLine -= 20
        }
        
        let pathForInclineLine = UIBezierPath()
        pathForInclineLine.move(to: referencePoint)
        pathForInclineLine.addLine(to: CGPoint(x:xInclineLine, y: yInclineLine))
        
        
        var xHorizontaLine = xInclineLine
        if (xHorizontaLine < self.center.x) {
                xHorizontaLine -= 20
        }
        if (xHorizontaLine > self.center.x) {
                xHorizontaLine += 20
        }
    
        let pathForHorizontalLine = UIBezierPath()
        pathForHorizontalLine.move(to: pathForInclineLine.currentPoint)
        pathForHorizontalLine.addLine(to: CGPoint(x: xHorizontaLine, y: pathForInclineLine.currentPoint.y ))
        
        let inclineLineLayer = CAShapeLayer()
        inclineLineLayer.frame = self.bounds
        inclineLineLayer.path = pathForInclineLine.cgPath
        inclineLineLayer.strokeColor = self.labelLineColor.cgColor
        inclineLineLayer.lineWidth = self.labelLineWidth
        inclineLineLayer.lineJoin = kCALineJoinBevel
        self.layer.addSublayer(inclineLineLayer)
        
        let horizontalLineLayer = CAShapeLayer()
        horizontalLineLayer.frame = self.bounds
        horizontalLineLayer.path = pathForHorizontalLine.cgPath
        horizontalLineLayer.strokeColor = self.labelLineColor.cgColor
        horizontalLineLayer.lineWidth = self.labelLineWidth
        horizontalLineLayer.lineJoin = kCALineJoinBevel
        self.layer.addSublayer(horizontalLineLayer)
        
        let pathAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.delegate = self
        pathAnimation.duration = 0.2
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        horizontalLineLayer.add(pathAnimation, forKey: "strokeEnd")
        inclineLineLayer.add(pathAnimation, forKey: "strokeEnd")
        
        var xForLabel = pathForHorizontalLine.currentPoint.x
        let yForLabel = pathForHorizontalLine.currentPoint.y - 15
        
        if (xForLabel > self.center.x) {
                xForLabel += 10
        }
        
        if (xForLabel < self.center.x) {
                xForLabel -= 30
        }
        
        self.daysLabel = UILabel(frame: CGRect(x: xForLabel,
                                      y: yForLabel,
                                      width: 30,
                                       height: 30))
        self.daysLabel.textAlignment = .center
        daysLabel.text = String(format:"%d", valueForLabel)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.addSubview(self.daysLabel)

    }
    
    func degreesToRadians (_ value:Double) -> Double {
        return value * Double(M_PI) / 180.0
    }
    
    func radiansToDegrees (_ value:Double) -> Double {
        return value * 180.0 / Double(M_PI)
    }

}
