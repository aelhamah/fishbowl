//  Adapted from from Tim Oliver's DittoLive Project (see acknowledgements)
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
    
    var rssiCounter: Int

    init(peripheral: CBPeripheral, name: String = "Unknown", rssi: String) {
        self.peripheral = peripheral
        self.name = name
        self.lastseen = Date()
        self.rssi = rssi
        self.rssiCounter = 30
    }
}
