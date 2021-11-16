//
//  FishesProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/16/21.
//

import Foundation

struct FishesProfile {
    
    var FishBowlID: String?

    var DisplayName: String?
    var Bio: String?
    var Gender: String?
    var Sexuality: String?
    var Relationship: String?
    @FishesPropWrapper var imageUrl: String?
    var imageData: Data?
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
