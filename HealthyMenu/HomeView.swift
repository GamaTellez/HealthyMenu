//
//  HomeView.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 9/8/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import MapKit

class HomeView: UIViewController {
    @IBOutlet var currentProteinCountLabel: CircledLabel!
    @IBOutlet var decrease: UIButton!
    @IBOutlet var increase: UIButton!
    var timer: Timer!
    @IBOutlet var goalLabel: CircledLabel!
    
    
    override func viewDidLoad() {
        self.increase.addTarget(self, action: #selector(self.add), for: UIControlEvents.touchDown)
        self.increase.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
        self.decrease.addTarget(self, action: #selector(self.substract), for: UIControlEvents.touchDown)
        self.decrease.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
    }
    
    func substract() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.currentProteinCountLabel.completed -= 1
            self.currentProteinCountLabel.text = String(format:"%.2f", self.currentProteinCountLabel.completed)
        })
    }
    
    func stop() {
        self.timer.invalidate()
        print("you let go of the button")
    }
    
    func add() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.currentProteinCountLabel.completed += 1
            self.currentProteinCountLabel.text = String(format:"%.2f", self.currentProteinCountLabel.completed)
        })
    }
}










