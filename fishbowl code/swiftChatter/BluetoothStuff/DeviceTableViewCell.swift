//
//  DeviceTableViewCell.swift
//  BluetoothChat
//
//  Created by Tim Oliver on 29/5/20.
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    var buttonTapCallback: () -> ()  = { }
     
     let button: UIButton = {
         let btn = UIButton()
         btn.setTitle("Finding...", for: .normal)
         btn.backgroundColor = .systemPink
         btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
         return btn
     }()
     
     var label: UILabel = {
        let lbl = UILabel()
         lbl.font = UIFont.systemFont(ofSize: 16)
         lbl.textColor = .systemPink
        return lbl
     }()
     
     @objc func didTapButton() {
         buttonTapCallback()
     }
    // Configure for when a specific device that was found
    public func configureForDevice(named user: UserProfile, selectable: Bool = true) {
        textLabel?.alpha = 1.0
        selectionStyle = selectable ? .blue : .none
        accessoryType = selectable ? .disclosureIndicator : .none
        for val in FishbowlStore.shared.users where val.Email == user.Email && val.DisplayName != "" {
            if let displayName = val.DisplayName! as? String {
                textLabel?.text = displayName
                button.setTitle(user.rssi, for: .normal)
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
        
        for var (index,value) in FishbowlStore.shared.users.enumerated() where value.Email == user.Email {
            FishbowlStore.shared.users[index].configuredCell = true
        }
        
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            //Add button
            contentView.addSubview(button)
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            
            //Set constraints as per your requirements
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 250).isActive = true
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            
            //Add label
            contentView.addSubview(label)
            //Set constraints as per your requirements
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 20).isActive = true
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    // Configure for a default placeholder state when no devices are found
    public func configureForNoDevicesFound() {
        textLabel?.alpha = 0.5
        selectionStyle = .none
        accessoryType = .none
        textLabel?.text = "No devices found."
        imageView?.image = nil
        button.setTitle("looking", for:.normal)
    }
}
