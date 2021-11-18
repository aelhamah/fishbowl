//
//  FishesProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/16/21.
//

import Foundation

struct FishesProfile {
    
    var FishBowlID: String?
    var Username: String?
    var FullName: String?
    var DisplayName: String?
    var Email: String?
    var Bio: String?
    var GenderPreference: String?
    var RelationshipPreference: String?
    @FishesPropWrapper var imageUrl: String?
    var imageData: Data?
    var rssi: String?
}

@propertyWrapper
struct FishesPropWrapper {
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
