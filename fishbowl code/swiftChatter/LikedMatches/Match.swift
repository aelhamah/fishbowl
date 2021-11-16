//
//  Match.swift
//  swiftChatter
//
//  Created by Sowgandhi Bhattu on 11/11/21.
//

import Foundation

struct Match {
    var username: String?


    @MatchPropWrapper var imageUrl: String?
    
}

@propertyWrapper
struct MatchPropWrapper {
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
