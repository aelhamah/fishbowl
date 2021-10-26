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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
                    print("BLE powered on")
                    // Turned on
                }
                else {
                    print("Something wrong with BLE")
                    // Not on, but can have different issues
                }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
           return ChattStore.shared.chatts.count
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
            
            let chatt = ChattStore.shared.chatts[indexPath.row]
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
            cell.usernameLabel.text = chatt.username
            cell.messageLabel.text = chatt.message
            cell.timestampLabel.text = chatt.timestamp
        
            if let urlString = chatt.imageUrl, let imageUrl = URL(string: urlString) {
                cell.chattImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
                cell.chattImageView.isHidden = false
            } else {
                cell.chattImageView.image = nil
                cell.chattImageView.isHidden = true
            }
        
            if let urlString = chatt.videoUrl, let videoUrl = URL(string: urlString) {
                cell.videoButton.isHidden = false // remember: cells are recycled and reused
                cell.playVideo = {
                    let avPlayerVC = AVPlayerViewController()
                    avPlayerVC.player = AVPlayer(url: videoUrl)
                    if let player = avPlayerVC.player {
                        self.present(avPlayerVC, animated: true) {
                            player.play()
                        }
                    }
                }
            } else {
                cell.videoButton.isHidden = true
                cell.playVideo = nil
            }
        
            return cell
        }
    
    private func refreshTimeline(_ sender: UIAction?) {
           ChattStore.shared.getChatts { success in
               DispatchQueue.main.async {
                   if success {
                       self.tableView.reloadData()
                   }
                   // stop the refreshing animation upon completion:
                   self.refreshControl?.endRefreshing()
               }
           }
       }
}
