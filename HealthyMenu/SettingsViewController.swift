//
//  SettingsViewController.swift
//  HealthyMenu
//
//  Created by Gamaliel Tellez on 3/29/17.
//  Copyright © 2017 Gamaliel Tellez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    let settingsTableViewDataSource = SettingsDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
    }
    
    private func setUpViews() {
        self.closeButton.setImage(UIImage(named:"closeIcon"), for: .normal)
        self.closeButton.clipsToBounds = true
            self.titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 30)
            self.titleLabel.textColor = UIColor.white
            self.setAppBackGroundColor()
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /********************************************************
     * tableview delegate methods
     *********************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentWalkThroughViewController()
    }

    private func presentWalkThroughViewController() {
            self.dismiss(animated: true, completion: {
                let walkThroughController = AppWalkThrouhController()
                UIApplication.shared.keyWindow?.rootViewController?.present(walkThroughController, animated: true, completion: nil)
            })
    }
}
