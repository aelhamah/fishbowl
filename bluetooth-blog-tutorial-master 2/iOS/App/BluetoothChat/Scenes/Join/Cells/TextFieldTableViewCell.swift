//
//  TextFieldTableViewCell.swift
//  BluetoothChat
//
//  Created by Tim Oliver on 29/5/20.
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    public var textFieldChangedHandler: ((String) -> Void)?
    public var profileImageChangedHandler: ((UIImage) -> Void)?

    // MARK: Text Field Delegate

    func textFieldDidEndEditing(_ textField: UITextField) {
        var deviceName = textField.text
        if deviceName?.count ?? 0 == 0 { deviceName = textField.placeholder ?? "Ditto" }
        if (profileImage.image == nil) {
            profileImage.image = UIImage(named:"afternoon")!
        }
        textFieldChangedHandler?(deviceName!)
        profileImageChangedHandler?(profileImage.image!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
