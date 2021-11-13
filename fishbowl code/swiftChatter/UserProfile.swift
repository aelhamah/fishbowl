//
//  UserProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import Foundation

struct UserProfile {
    
    var FishBowlID: String?
    var Username: String?
    var FullName: String?
    var DisplayName: String?
    var Email: String?
    var Bio: String?
    @ProfilePropWrapper var imageUrl: String?
}

@propertyWrapper
struct ProfilePropWrapper {
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
