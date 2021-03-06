//  Adapted from from Tim Oliver's DittoLive Project (see acknowledgements)


import Foundation
import CoreBluetooth
import Alamofire

/// A service that both advertises this current device,
/// and scans for other devices also performing the same advertisement
/// over Bluetooth.
class BluetoothDeviceDiscovery: NSObject {

    // MARK: - Public Members -

    /// The name of this device that will be advertised to others
    public var deviceName = "Ditto" {
        didSet { startAdvertising() }
    }
    
    var discoveryTimer : Timer =  Timer()
    var isAdvertising : Bool = true

    /// A list of devices that have been discovered by this device
    private(set) public var devices = [Device]()

    /// A closure that is called whenever the list of devices is updated
    public var devicesListUpdatedHandler: (() -> Void)?

    // MARK: - Private Members -

    // The central manager scans for other devices advertising themselves
    private var centralManager: CBCentralManager!

    // The peripheral manager handles advertising this device to other devices
    private var peripheralManager: CBPeripheralManager!

    // Make a queue we can run all of the events off
    private let queue = DispatchQueue(label: "live.ditto.bluetooth-discovery",
                                      qos: .background, attributes: .concurrent,
                                      autoreleaseFrequency: .workItem, target: nil)

    /// Create a new instance of this discovery class.
    /// Will start scanning and advertising immediately
    init(deviceName: String? = nil) {
        super.init()
        // Create the Bluetooth devices (Which will immediately start warming them up)
        self.centralManager = CBCentralManager(delegate: self, queue: queue)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
        // If a device name is provided, capture it
        // If let deviceName = deviceName { self.deviceName = deviceName }
        // Set device name
        self.deviceName = Fishbowl_ID.shared.id
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            print("processing")
            for (index, device) in self.devices.enumerated() {
                print("looking at "+device.name)
                if device.lastseen + TimeInterval(5) < Date() {
                    self.devices.remove(at: index)
                    for (index,value) in FishbowlStore.shared.users.enumerated() where value.Email == device.name {
                        //remove them from list so that we can try again
                        FishbowlStore.shared.users.remove(at: index)
                        break
                    }
                    print("removed "+device.name)
                    self.devicesListUpdatedHandler?()
                    break
                }
            }
//
//            if randomNumber == 10 {
//                timer.invalidate()
//            }
        }
    }
    // Start advertising (Or re-advertise) this device as a peipheral
    func startAdvertising() {
        // Don't start until we've finished warming up
        guard peripheralManager.state == .poweredOn else { return }

        isAdvertising = true
        // Stop advertising if we're already in progress
//        if peripheralManager.isAdvertising { peripheralManager.stopAdvertising() }
        
        // Start advertising with this device's name
        peripheralManager.startAdvertising(
            [CBAdvertisementDataServiceUUIDsKey: [BluetoothConstants.chatDiscoveryServiceID],
             CBAdvertisementDataLocalNameKey: deviceName])
    }

    func stopAdvertising() {
        // Stop advertising if we're already in progress
        print("bluetooth discovery stop advetisnig")
        // Stop advertising if we're already in progress
        isAdvertising = false
        peripheralManager.stopAdvertising()
        devices = [Device]()
        FishbowlStore.shared.users = [UserProfile]()
    }
    
    // Get image data
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    // Download image
    public func downloadImage(from url: URL, deviceName:String, completion: @escaping (_ success: Bool) -> ()) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                print("unable to get image")
                
                let url = "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg"
                self.downloadImage(from: URL(string:url)!, deviceName:deviceName, completion: completion)
                return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async { [weak self] in
                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email ==  deviceName{
                    FishbowlStore.shared.users[index].imageData = data;
                }
                completion(true)
                
            }
        }
    }
    
    func getIndividualProfile(email: String, users: inout [UserProfile], completion: @escaping (_ success: Bool) -> ()) {
        guard let apiUrl = URL(string: "http://3.15.21.206/"+"getusers/") else {
            print("getProfile: bad URL")
            print("Getting image with dummy image")
            // use dummy image
            let url = "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg"
            //            self.downloadImage(from: URL(string: url)!)
            return
        }
        let parameters: [String: String] = ["user_ids": email, "sender": Fishbowl_ID.shared.email]
        print(apiUrl)
        var url = ""
        AF.request(apiUrl, method: .get, parameters: parameters,
                   encoding: URLEncoding.default).responseJSON { response in
            guard let data = response.data, response.error == nil else {
                print("getProfile: NETWORKING ERROR")
                completion(false)
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data)
                    as? [String: Any] else {
                        print("getProfile: failed JSON deserialization")
                        completion(false)
                        return
                    }
            var usersReceived: [String: [String: Any]] = [:]
            usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>> // swiftlint:disable:this force_cast
            if (usersReceived.count == 0) {
                return completion(false)
            }
            for (_, value) in usersReceived {
                print("Username", value["username"]!)
                print("DisplayName", value["display_name"]!)
                print("ImageURL", value["imageurl"]!)
                print("Email", value["email"]!)
                print("ID Token", value["token"])
            }
            
            for (_, value) in usersReceived where value["token"] as? String == email  {// swiftlint:disable:this force_cast
                print(FishbowlStore.shared.users.count)
                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email == email {
                    FishbowlStore.shared.users[index].DisplayName = (value["display_name"] as? String)
                    
                    FishbowlStore.shared.users[index].Bio = (value["bio"] as? String)
                    FishbowlStore.shared.users[index].GenderPreference = (value["gender_preference"] as? String)
                    FishbowlStore.shared.users[index].RelationshipPreference = (value["relationship_preference"] as? String)
                    FishbowlStore.shared.users[index].Actual_Email = (value["email"] as? String)
                    FishbowlStore.shared.users[index].likes_sender = (value["likes_sender"] as? Bool)
                    
                    if value["imageurl"] != nil {
                        url = ((value["imageurl"] as? String)!)// swiftlint:disable:this force_cast
                        FishbowlStore.shared.users[index].imageUrl = url
                    }
                }
//                completion(true)
            }
            // download the image from given image url
            if url != "" {
                self.downloadImage(from: URL(string: url)!, deviceName:email, completion: completion)// swiftlint:disable:this force_cast
                
            } else {
                url = "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg"
                self.downloadImage(from: URL(string:url)!, deviceName:email, completion: completion)// swiftlint:disable:this force_cast
            }
            
        }
    }

    // If a new device is discovered by the central manager, update the visible list
    fileprivate func updateDeviceList(with device: Device) {
        // If a device already exists in the list, replace it with this new device
        if let index = devices.firstIndex(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            guard devices[index].name != device.name else {
                devices[index].rssiCounter -= 1
                if  devices[index].rssiCounter == 0 {
                    if devices[index].rssi != device.rssi
                    {
                        devices[index].rssi = device.rssi
                        devicesListUpdatedHandler?()
                    }
                    devices[index].rssiCounter = 30
                }
               
                return
                
            }
//            devices.remove(at: index)
////            FishbowlStore.shared.devices.remove(at: index)
//            devices.insert(device, at: index)
//            FishbowlStore.shared.insert(device, at:index)
            if peripheralManager.isAdvertising {
                devices[index].lastseen = Date()
            }
//            devices[index].rssi = device.rssi
//            devicesListUpdatedHandler?()
            return
        }
        
        

        // If this item didn't exist in the list, append it to the end
        if peripheralManager.isAdvertising {
           var tempBool = false
            
            for (index, value) in FishbowlStore.shared.users.enumerated() where value.Email == device.name {
                tempBool = true
            }
            
            if tempBool == false {
            
                FishbowlStore.shared.users.append(UserProfile(DisplayName: "", Email:  device.name, rssi: device.rssi, configuredCell: false))
            getIndividualProfile(email: device.name, users: &FishbowlStore.shared.users) {success in
                DispatchQueue.main.async {
                    print("reached here")
                    if success {
                        print("Success")
                        self.devices.append(device)
                        self.devicesListUpdatedHandler?()

                    } else {
                        print("Error")
                        for (index,value) in FishbowlStore.shared.users.enumerated() where value.Email == device.name {
                            //remove them from list so that we can try again
                            FishbowlStore.shared.users.remove(at: index)
                        }
                    }
                }
            }
            }
           
        }
        
        devicesListUpdatedHandler?()
    }
}

extension BluetoothDeviceDiscovery: CBCentralManagerDelegate {
    // Called when the Bluetooth central state changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }

        // Start scanning for peripherals
        centralManager.scanForPeripherals(withServices: [BluetoothConstants.chatDiscoveryServiceID],
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func classifyProximity(rssi RSSI: NSNumber) -> String {
        
        if Int(RSSI) > -50 {
            return "HOT"
        } else if Int(RSSI) > -75 {
            return "WARM"
        } else if Int(RSSI) > -125 {
            return "COLD"
        } else {
            return "ICE"
        }
    }

    // Called when a peripheral is detected
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Get the string value of the UUID of this device as the default value
        var name = peripheral.identifier.description
        // Attempt to get the user-set device name of this peripheral
        if let deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            name = deviceName
        }

        // Capture all of this in a device object
        let device = Device(peripheral: peripheral, name: name, rssi: classifyProximity(rssi: RSSI) )
        // Add or update this object to the visible list
//        print("Device Name:", device.name)
//        print("RSSI:", device.rssi)
        DispatchQueue.main.async { [weak self] in
//            if ((self?.isAdvertising) == true) {
                self?.updateDeviceList(with: device)
                
//            }
        
        }
    }
}

extension BluetoothDeviceDiscovery: CBPeripheralManagerDelegate {
    // Called when the Bluetooth peripheral state changes
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else { return }

        // Start advertising this device as a peripheral
        startAdvertising()
    }
}
