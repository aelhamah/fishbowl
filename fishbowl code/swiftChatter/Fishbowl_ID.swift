//
//  Fishbowl_ID.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/11/21.
//
import Foundation

final class Fishbowl_ID {
    static let shared = Fishbowl_ID() // create one instance of the class to be shared
    private init(){}                // and make the constructor private so no other
                                    // instances can be created
    
    var expiration = Date(timeIntervalSince1970: 0.0)
    private var field: String?
    var id: String? {
        get { Date() >= expiration ? nil : field }
        set(newValue) { field = newValue }
    }
}
