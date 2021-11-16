//
//  DeviceTableViewCell.swift
//  BluetoothChat
//
//  Created by Tim Oliver on 29/5/20.
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    // Configure for when a specific device that was found
    public func configureForDevice(named user: UserProfile, selectable: Bool = true) {
        textLabel?.alpha = 1.0
        selectionStyle = selectable ? .blue : .none
        accessoryType = selectable ? .disclosureIndicator : .none
        for val in FishbowlStore.shared.users where val.Email == user.Email {
            if let displayName = val.DisplayName! as? String {
                textLabel?.text = displayName
            } else {
                textLabel?.text = "Loading Name"
            }
//         Set profile image for landing page
            if val.imageData != nil {
                self.imageView?.contentMode = .scaleAspectFit
//                self.imageView?.image = UIImage(named: "afternoon.png")
                self.imageView?.image = UIImage(data: (val.imageData!))
            } else {
                imageView?.image = nil
            }
        }
    }

    // Configure for a default placeholder state when no devices are found
    public func configureForNoDevicesFound() {
        textLabel?.alpha = 0.5
        selectionStyle = .none
        accessoryType = .none
        textLabel?.text = "No devices found."
    }
}
