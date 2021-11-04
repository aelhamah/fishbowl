//
//  MainVC.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import Foundation
import UIKit
import AVKit
import SDWebImage
import CoreBluetooth

final class MainVC: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var uuidDict: [UUID: [String : Any]] = [:]

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
            case .poweredOn:
                print("BLE powered on")
                let deviceInfoProfileCBUUID = CBUUID(string: "0x180A")
//                central.scanForPeripherals(withServices: nil, options: nil)
            
            case .poweredOff: break
                // Alert user to turn on Bluetooth
            case .resetting: break
                // Wait for next state update and consider logging interruption of Bluetooth service
            case .unauthorized:break
                // Alert user to enable Bluetooth permission in app Settings
            case .unsupported:break
                // Alert user their device does not support Bluetooth and app will not work as expected
            case .unknown:break
               // Wait for next state update
        @unknown default:
            print("Something wrong with BLE")

        }
    }
    
    
        
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
                //Perform search every 20 seconds
        print("in central manager")

//        let seconds = 20.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
//            if let pname = peripheral.name {
//                if pname == "iPhone"{
//                    self.centralManager.stopScan()
//                    self.myPeripheral = peripheral
//                    self.myPeripheral.delegate = self
//                    self.centralManager.connect(peripheral, options: nil)
//
//                // TO DO try to get device information profile system id instead
//                if (self.uuidDict[peripheral.identifier] == nil) {
//                    // advertisement data
//                    var data = advertisementData
//                    // # value of distance away
//                    data["rssi"] = RSSI
//                    // name of device
//                    data["pname"] = peripheral.name
//                    self.uuidDict[peripheral.identifier] = data
//                    print(pname)
//                    print(peripheral.identifier)
//                }
//                }
//            }
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.myPeripheral.discoverServices(nil)

    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services)
        let t = CBUUID(string:"0x2A23")
        for service: CBService in peripheral.services! {
            self.myPeripheral.discoverCharacteristics(nil, for: service )
        }
        
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(service.characteristics)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.rowHeight = 80;
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // setup refreshControler here later
               refreshControl?.addAction(UIAction(handler: refreshTimeline), for: UIControl.Event.valueChanged)
               
               refreshTimeline(nil)
    }
    // MARK:- TableView handlers

       override func numberOfSections(in tableView: UITableView) -> Int {
           // how many sections are in table
           return 1
       }
       
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // how many rows per section
           return FishbowlStore.shared.users.count
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // event handler when a cell is tapped
           tableView.deselectRow(at: indexPath as IndexPath, animated: true)
       }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // populate a single cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattTableCell", for: indexPath) as? ChattTableCell else {
                fatalError("No reusable cell!")
            }
            
            let user = FishbowlStore.shared.users[indexPath.row]
            print("here")
            print(user)
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
            cell.usernameLabel.text = user.username
//            cell.messageLabel.text = chatt.message
//            cell.timestampLabel.text = chatt.timestamp
        
            if let urlString = user.imageUrl, let imageUrl = URL(string: urlString) {
                cell.chattImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
                cell.chattImageView.isHidden = false
            } else {
                cell.chattImageView.image = nil
                cell.chattImageView.isHidden = true
            }
            return cell
        }
    
    private func refreshTimeline(_ sender: UIAction?) {
        let user_list = [1]
           FishbowlStore.shared.getProfile(user_list)
//        { success in
//               DispatchQueue.main.async {
//                   if success {
//                       self.tableView.reloadData()
//                   }
//                   // stop the refreshing animation upon completion:
//                   self.refreshControl?.endRefreshing()
//               }
//           }
        
        //FishbowlStore.shared.getProfile(true, user_list)
       }
    
}
