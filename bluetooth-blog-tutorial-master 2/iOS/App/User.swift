//
//  User.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//
import Foundation
struct User {
    var displayName: String?
    var email: String?
    var imageData: Data?
}

@propertyWrapper
struct UserPropWrapper {
    private var _value: String?
    var wrappedValue: String? {
        get { _value }
        set {
            guard let newValue = newValue else {
                _value = nil
                return
            }
            _value = (newValue == "null" || newValue.isEmpty) ? nil : newValue
        }
    }
    
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
}
