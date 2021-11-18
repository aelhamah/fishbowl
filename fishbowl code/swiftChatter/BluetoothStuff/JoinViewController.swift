//
//  JoinViewController.swift
//  FishBowl
//
//  Created by Rithika Ganesh on 10/21/21
//  Copyright © 2020 DittoLive Incorporated. All rights reserved.
//

import UIKit
import Alamofire

struct Sections {
    static let name = 0
    static let availableDevices = 1
}

class JoinViewController: UITableViewController {
    
    // The static identifiers for the celbls we'll be using
    static let deviceCellIdentifier = "DeviceCell"
    static let nameCellIdentifier = "NameCell"
    
    // The name of this device
    private var deviceName = UIDevice.current.name {
        didSet { deviceDiscovery.deviceName = deviceName }
    }
    // The email associated with this device
    //    private var deviceEmailIdentity = "rg@umich.edu"
    
    // The Bluetooth service manager for advertising and scanning
    private var deviceDiscovery: BluetoothDeviceDiscovery!
    private var peripheralDeviceEmail = ""
    // MARK: - Class Creation -
    
    init() {
        super.init(style: .insetGrouped)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View Configuration -
    @objc func sampleSwitchValueChanged(sender: UISwitch!) {
        if sender.isOn {
            print("switch on")
        } else {
            print("switch not on")
        }
    }
    @objc func stopAdvertising() {
        // Stop advertising if we're already in progress
        deviceDiscovery.stopAdvertising()
    }
    @objc func startAdvertising() {
        // Stop advertising if we're already in progress
        deviceDiscovery.startAdvertising()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up and run the device discovery service
        deviceDiscovery = BluetoothDeviceDiscovery(deviceName: deviceName)
        deviceDiscovery.devicesListUpdatedHandler = { [weak self] in
            guard let tableView = self?.tableView else { return }
            tableView.reloadSections([Sections.availableDevices], with: .automatic)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(stopAdvertising),
                                               name: Notification.Name("bluetoothManagementOff"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startAdvertising),
                                               name: Notification.Name("bluetoothManagementOn"), object: nil)
        // Register the cells we plan to use
        tableView.register(DeviceTableViewCell.self,
                           forCellReuseIdentifier: JoinViewController.deviceCellIdentifier)
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil),
                           forCellReuseIdentifier: JoinViewController.nameCellIdentifier)
        
        // Set up the header view
        tableView.tableHeaderView = JoinTableHeaderView.instantiate()

    }
    
//    // Get image data
//    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
// 
//    }
//    // Download image
//    public func downloadImage(from url: URL, completion: @escaping (_ success: Bool) -> ()) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("unable to get image")
////                let url = "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg"
//                
//                let url = "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg"
//                self.downloadImage(from: URL(string:url)!, completion: completion)
//                return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async { [weak self] in
//                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email ==  self?.peripheralDeviceEmail {
//                    FishbowlStore.shared.users[index].imageData = data;
//                }
//                completion(true)
//                
//            }
//        }
//    }
    // get individual profile for a given user detected with bluetooth & find display name and display image
//    func getIndividualProfile(email: String, users: inout [UserProfile], completion: @escaping (_ success: Bool) -> ()) {
//        guard let apiUrl = URL(string: "http://3.15.21.206/"+"getusers/") else {
//            print("getProfile: bad URL")
//            print("Getting image with dummy image")
//            // use dummy image
//            let url = "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg"
//            //            self.downloadImage(from: URL(string: url)!)
//            return
//        }
//        let parameters: [String: String] = ["user_ids": email]
//        print(apiUrl)
//        var url = ""
//        AF.request(apiUrl, method: .get, parameters: parameters,
//                   encoding: URLEncoding.default).responseJSON { response in
//            guard let data = response.data, response.error == nil else {
//                print("getProfile: NETWORKING ERROR")
//                completion(false)
//                return
//            }
//            guard let jsonObj = try? JSONSerialization.jsonObject(with: data)
//                    as? [String: Any] else {
//                        print("getProfile: failed JSON deserialization")
//                        completion(false)
//                        return
//                    }
//            var usersReceived: [String: [String: Any]] = [:]
//            usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>> // swiftlint:disable:this force_cast
//            if (usersReceived.count == 0) {
//                return completion(false)
//            }
//            for (_, value) in usersReceived {
//                print("Username", value["username"]!)
//                print("DisplayName", value["display_name"]!)
//                print("ImageURL", value["imageurl"]!)
//                print("Email", value["email"]!)
//                print("ID Token", value["token"])
//            }
//            
//            for (_, value) in usersReceived where value["token"] as? String == self.peripheralDeviceEmail  {// swiftlint:disable:this force_cast
//                print(FishbowlStore.shared.users.count)
//                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email == self.peripheralDeviceEmail {
//                    FishbowlStore.shared.users[index].DisplayName = (value["display_name"] as? String)
//                    if value["imageurl"] != nil {
//                        url = ((value["imageurl"] as? String)!)// swiftlint:disable:this force_cast
//                        FishbowlStore.shared.users[index].imageUrl = url
//                    }
//                }
////                completion(true)
//            }
//            // download the image from given image url
//            if url != "" {
//                self.downloadImage(from: URL(string: url)!, completion: completion)// swiftlint:disable:this force_cast
//                
//            } else {
//                url = "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg"
//                self.downloadImage(from: URL(string:url)!, completion: completion)// swiftlint:disable:this force_cast
//            }
//            
////            for value in FishbowlStore.shared.users where value.email == self.peripheralDeviceEmail {
////                cell.configureForDevice(named: value, selectable: false)
////            }
////            self.tableView.reloadData()
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If we're in a navigation controller, hide the bar
        if let navigationController = self.navigationController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
}

// MARK: - Table View Data Source
extension JoinViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.name { return 0 }
        return max(deviceDiscovery.devices.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // For the devices cells, dequeue one of the device cells and configure

        var tempBool = false
                // For the devices cells, dequeue one of the device cells and configure
//        if deviceDiscovery.devices.count > 0 {
//        let device = deviceDiscovery.devices[indexPath.row]
//                    for var (index, value) in FishbowlStore.shared.users.enumerated() where value.Email == self.peripheralDeviceEmail {
//                        //                    print("email already exists")
//
//                        for (i, x) in deviceDiscovery.devices.enumerated() where x.name == self.peripheralDeviceEmail {
//                            if x.rssi != device.rssi {
//                                print("Editing RSSI Value")
//
//                                FishbowlStore.shared.users[index].rssi = device.rssi
//                                self.tableView.reloadData()
//                                //                    return cell
//                            }
//                        }
//                        //            return cell
//                        tempBool = true
//                    }
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinViewController.deviceCellIdentifier,
                                                 for: indexPath)
        if let deviceCell = cell as? DeviceTableViewCell {
            
                    // If we have a list of devices, configure each cell with its name
                    if deviceDiscovery.devices.count > 0 {
                        let device = deviceDiscovery.devices[indexPath.row]
                        for var (index, value) in FishbowlStore.shared.users.enumerated() where value.Email == device.name {
                        deviceCell.configureForDevice(named: value)
                        }
                    } else {
                        // If no devices found, show "no devices"
                        deviceCell.configureForNoDevicesFound()
                    }
                }

                return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Sections.availableDevices { return "Available Devices" }
        return ""
    }
}

// MARK: - Table View Delegate -
extension JoinViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == Sections.availableDevices,
                deviceDiscovery.devices.count > 0 else { return }
        
        FishbowlStore.shared.fishies = FishesProfile(FishBowlID: "1", Username: "nic", FullName: "nic", DisplayName: "nic", Email: "nic", Bio: "nic", GenderPreference: "nic", RelationshipPreference: "nic", imageUrl: nil, imageData: nil, rssi: "nic")
        
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProfilePageView") as! ProfilePage
        self.navigationController?.pushViewController(myVC, animated: true)


        // Create a chat view controller and present it
//        let chatViewController = ChatViewController(device: deviceDiscovery.devices[indexPath.row],
//                                                    currentDeviceName: deviceName)
//        navigationController?.pushViewController(chatViewController, animated: true)

    }
}
