//
//  Device.swift
//  BluetoothChat
//
//  Created by Tim Oliver on 31/5/20.
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import Foundation
import CoreBluetooth

/// A device, as detected through
/// a Bluetooth service advertisement
struct Device {
    /// The peripheral object associated with this device
    let peripheral: CBPeripheral

    /// The reported name of this device
    var name: String
    
    var lastseen : Date
    
    var rssi : String
//    var email:String

    init(peripheral: CBPeripheral, name: String = "Unknown", rssi: String) {
        self.peripheral = peripheral
        self.name = name
        self.lastseen = Date()
        self.rssi = rssi
//        self.email = email
    }
}
