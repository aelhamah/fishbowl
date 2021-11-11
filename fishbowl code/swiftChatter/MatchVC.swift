//
//  MatchVC.swift
//  swiftChatter
//
//  Created by Sowgandhi Bhattu on 11/11/21.
//


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

final class MatchVC: UITableViewController {
 


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return FishbowlStore.shared.matches.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // event handler when a cell is tapped
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // populate a single cell
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableCell", for: indexPath) as? MatchTableCell else {
               fatalError("No reusable cell!")
           }
           
           let match = FishbowlStore.shared.matches[indexPath.row]
           cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6

        
           if let urlString = match.imageUrl, let imageUrl = URL(string: urlString) {
                    cell.matchImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
                    cell.matchImageView.isHidden = false
                } else {
                    cell.matchImageView.image = nil
                    cell.matchImageView.isHidden = true
                }
       
           return cell
       }
    private func refreshTimeline(_ sender: UIAction?) {
            FishbowlStore.shared.getChatts { success in
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
