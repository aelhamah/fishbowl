//
//  JoinTableHeaderView.swift
//  BluetoothChat
//
//  Created by Tim Oliver on 31/5/20.
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import UIKit

/// The view shown along the top of the join view controller
class JoinTableHeaderView: UIView {

    @IBOutlet weak var container: UIView!
   
    @IBOutlet weak var titleLabel: UILabel!

    class func instantiate() -> UIView {
        let views = UINib(nibName: "JoinTableHeaderView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
        guard let view = views.first as? UIView else {
            fatalError("Was unable to locate JoinTableHeaderView XIB on disk")
        }
        return view
    }
    @IBAction func toggleBluetooth(_ sender: UISwitch) {
        if sender.isOn{
            print("ON")
            NotificationCenter.default.post(name: Notification.Name("bluetoothManagementOn"), object: nil)
        } else {
            print("OFF")
            NotificationCenter.default.post(name: Notification.Name("bluetoothManagementOff"), object: nil)
        }
    }
    override func awakeFromNib() {
        // Give the logo view rounded corners
//        let logoLayer = logoView.layer
//        logoLayer.cornerRadius = 40.0
//        logoLayer.cornerCurve = .continuous
//        logoLayer.masksToBounds = true
//
//        // Add a subtle drop shadow underneath the logo
//        let logoContainerLayer = logoContainer.layer
//        logoContainerLayer.shadowOpacity = 0.15
//        logoContainerLayer.shadowColor = UIColor.black.cgColor
//        logoContainerLayer.shadowRadius = 30.0
//        logoContainerLayer.shadowPath = UIBezierPath(roundedRect: logoView.bounds, cornerRadius: 40).cgPath
    }
}
