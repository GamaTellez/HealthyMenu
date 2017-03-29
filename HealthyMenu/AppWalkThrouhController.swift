//
//  AppWalkThrouhController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/29/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit
import Gecco
class AppWalkThrouhController: SpotlightViewController {

        var totalViews = 4
        var stepIndex: Int = 0
        let screenSize = UIScreen.main.bounds.size
        let messageLabel = UILabel()
        let continueButton = UIButton()
        let temporaryView = UIView()
        override func viewDidLoad() {
            super.viewDidLoad()
            //Mark: set up temporary view
            self.temporaryView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            self.temporaryView.backgroundColor = UIColor.white
            self.view.addSubview(self.temporaryView)
            //Mark: create message label
            self.messageLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                                     height: 80)
            self.messageLabel.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
            self.messageLabel.textAlignment = .center
            self.messageLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
            self.messageLabel.numberOfLines = 0
            self.messageLabel.textColor = .black
            self.messageLabel.alpha = 0.8
            self.messageLabel.text = "Tap to button below to walk through the instructions"
            self.view.addSubview(messageLabel)
            //Mark: continue button
            self.continueButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.continueButton.center = CGPoint(x: messageLabel.center.x, y: messageLabel.center.y + continueButton.frame.height + 10)
            self.continueButton.addTarget(self, action: #selector(nextSpotLightView), for: .touchUpInside)
            self.continueButton.setImage(UIImage(named:"next")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.continueButton.layer.cornerRadius = continueButton.frame.width / 2
            self.continueButton.tintColor = UIColor.black
            self.continueButton.layer.borderWidth = 0.5
            self.view.addSubview(continueButton)
        }
        
        @objc func nextSpotLightView() {
            self.temporaryView.removeFromSuperview()
            self.messageLabel.textColor = UIColor.white
            self.continueButton.tintColor = UIColor(red: 0.086, green: 0.463, blue: 0.910, alpha: 1.00)
            self.continueButton.layer.borderColor = UIColor(red: 0.086, green: 0.463, blue: 0.910, alpha: 1.00).cgColor
            
            switch stepIndex {
            case 0:
                //Mark:addGoal bar button item spotlight
                spotlightView.appear(Spotlight.Oval(center: CGPoint(x: screenSize.width - 28, y: 42), diameter: 50))
                self.messageLabel.text = "First add a goal to start keeping track of your protein intake. It automatically adds a day."
            case 1:
                //Mark: addDay bar button item spotlight
               spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: 42), size: CGSize(width: 120, height: 40), cornerRadius: 6), moveType: .disappear)
                 self.messageLabel.text = "Add a new day every time your reached your goal or if it is a new day."
            case 2:
                //Mark: addProtein button spotlight
                spotlightView.move(Spotlight.RoundedRect(center: CGPoint(x: screenSize.width / 2, y: screenSize.height - 45), size: CGSize(width:120, height: 40), cornerRadius: 6), moveType: .disappear)
                self.messageLabel.text = "To add protein to your count, you need to add a meal.You can do it manualy or just search in the nutrionix.com database."
            case 3:
                //Mark: view goal stats
                spotlightView.move(Spotlight.Oval(center: CGPoint(x: 28, y: 40), diameter: 50), moveType: .disappear)
                self.messageLabel.text = "View how you are doing in keeping track of your protein intake."
            case 4:
                dismiss(animated: true, completion: nil)
            default:
                break
            }
            
            stepIndex += 1
        }
}
