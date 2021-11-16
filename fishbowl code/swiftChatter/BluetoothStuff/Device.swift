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

    init(peripheral: CBPeripheral, name: String = "Unknown") {
        self.peripheral = peripheral
        self.name = name
        self.lastseen = Date()
    }
}