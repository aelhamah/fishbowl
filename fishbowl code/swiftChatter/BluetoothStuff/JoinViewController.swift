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
        super.isModalInPresentation = true;

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

//        var val = (deviceDiscovery.devices.count - 1)
//        var peripheralDevice = deviceDiscovery.devices[val]
//        FishbowlStore.shared.users.append(User(displayName: "", email: peripheralDevice.name ))
//
//        getIndividualProfile(email: self.peripheralDeviceEmail, users: &FishbowlStore.shared.users) {success in
//               DispatchQueue.main.async {
//                   print("reached here")
//                   if success {
//                       print("Success")
//                   } else {
//                       print("Error")
//                   }
//                   // stop the refreshing animation upon completion:
//                   self.refreshControl?.endRefreshing()
//               }
//        }
    }

    // Get image data
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    // Download image
    public func downloadImage(from url: URL, cell: DeviceTableViewCell) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async { [weak self] in
                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email ==  self?.peripheralDeviceEmail {
                    FishbowlStore.shared.users[index].imageData = data;
            }
                for value in FishbowlStore.shared.users where value.Email == self?.peripheralDeviceEmail {
                    cell.configureForDevice(named: value, selectable: false)
                }
                self?.tableView.reloadData()
            }
        }
    }
    // get individual profile for a given user detected with bluetooth & find display name and display image
    func getIndividualProfile(email: String, users: inout [UserProfile], cell: DeviceTableViewCell, _ completion: ((Bool) -> Void)? ) {
        guard let apiUrl = URL(string: "http://3.15.21.206/"+"getusers/") else {
            print("getProfile: bad URL")
            return
        }
        let parameters: [String: String] = ["user_ids": email]
        print(apiUrl)
        var url = ""
        AF.request(apiUrl, method: .get, parameters: parameters,
                   encoding: URLEncoding.default).responseJSON { response in
            guard let data = response.data, response.error == nil else {
                print("getProfile: NETWORKING ERROR")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data)
                    as? [String: Any] else {
                print("getProfile: failed JSON deserialization")
                return
            }
            var usersReceived: [String: [String: Any]] = [:]
            usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>> // swiftlint:disable:this force_cast
//            for (_, value) in usersReceived {
//                    print(value["username"]!)
//                    print(value["display_name"]!)
//                    print(value["imageurl"]!)
//                    print(value["email"]!)
//            }
            for (_, value) in usersReceived where value["email"] as! String == self.peripheralDeviceEmail  {// swiftlint:disable:this force_cast
                print(FishbowlStore.shared.users.count)
                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email == self.peripheralDeviceEmail {
                    FishbowlStore.shared.users[index].DisplayName = (value["display_name"] as? String)
                    // TODO: get url from here and store in url variable below
//                    FishbowlStore.shared.users[index].imageUrl = (value["imageurl"] as? String)
                    if value["imageurl"] != nil {
                        url = ((value["imageurl"] as? String)!)// swiftlint:disable:this force_cast
                    }
                }
            }
            // download the image from given image url
            if url != "" {
                self.downloadImage(from: URL(string: "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg")!, cell:cell)// swiftlint:disable:this force_cast

            } else {
                url = "http://3.15.21.206/media/Taylor1636832650.1411505.jpeg"
                self.downloadImage(from: URL(string:url)!, cell:cell)// swiftlint:disable:this force_cast
            }

//            for value in FishbowlStore.shared.users where value.email == self.peripheralDeviceEmail {
//                cell.configureForDevice(named: value, selectable: false)
//            }
//            self.tableView.reloadData()
        }
    }
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

//        // For the name section, dequeue a text field cell and configure it
        if indexPath.section == Sections.name {

            // Ideally, we'll make the device name editable.
            // This code shows a table cell with an editable text field

            // CHANGE USER NAME
             let cell = tableView.dequeueReusableCell(withIdentifier: JoinViewController.nameCellIdentifier,
                                                     for: indexPath)
             if let nameCell = cell as? TextFieldTableViewCell {
                 nameCell.textField.text = deviceName
                 nameCell.textFieldChangedHandler = { [weak self] name in
                     self?.deviceName = name
                 }
             }
            if let deviceCell = cell as? DeviceTableViewCell {
                let device = deviceDiscovery.devices[indexPath.row]
                for value in FishbowlStore.shared.users where value.Email ==  self.peripheralDeviceEmail {
                    deviceCell.configureForDevice(named: value, selectable: false)
                }
            } else {
                if let deviceCell = cell as? DeviceTableViewCell {
                print("unable to configure table cell for device")
//                    deviceCell.configureForDevice(named: User(displayName: "", email: ""), selectable: false)
                }
            }
            return cell
        }

        // For the devices cells, dequeue one of the device cells and configure
        let cell = tableView.dequeueReusableCell(withIdentifier: JoinViewController.deviceCellIdentifier,
                                                 for: indexPath)
        if let deviceCell = cell as? DeviceTableViewCell {

            // If we have a list of devices, configure each cell with its name
            if deviceDiscovery.devices.count > 0 {
                let device = deviceDiscovery.devices[indexPath.row]
                self.peripheralDeviceEmail = (device.name) // swiftlint:disable:this force_cast

                for value in FishbowlStore.shared.users where value.Email == self.peripheralDeviceEmail {
                    print("email already exists")

                    return cell
                }

                FishbowlStore.shared.users.append(UserProfile(DisplayName: "", Email:  self.peripheralDeviceEmail ))
                getIndividualProfile(email:  self.peripheralDeviceEmail, users: &FishbowlStore.shared.users, cell: deviceCell) {success in
                    DispatchQueue.main.async {
                        print("reached here")
                        if success {
                            print("Success")
                        } else {
                            print("Error")
                        }
                        // stop the refreshing animation upon completion:
//                        tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
             }
//            for value in FishbowlStore.shared.users where value.email == self.peripheralDeviceEmail {
//                deviceCell.configureForDevice(named: value, selectable: false)
//            }

            } else {
                // If no devices found, show "no devices"
                // KEEP FOR TESTING
//                for value in FishbowlStore.shared.users where value.email == self.deviceEmailIdentity {
//                    deviceCell.configureForDevice(named: value, selectable: false)
//                }
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

        // Create a chat view controller and present it
//        let chatViewController = ChatViewController(device: deviceDiscovery.devices[indexPath.row],





        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProfilePageView") as! ProfilePage
        self.navigationController?.pushViewController(myVC, animated: true)
//        self.navigationController?.pushViewController(ProfilePage(), animated: true)
//
//        navigationController?.pushViewController(ProfilePage(), animated: true)
//        currentDeviceName: deviceName)
//        let profilePageViewController =
//
//        let vc = storyboard.instantiateViewController(withIdentifier: "myVCID")
//        self.present(vc, animated: true)
//        navigationController?.pushViewController(profilePageViewController, animated: true)

    }
}
