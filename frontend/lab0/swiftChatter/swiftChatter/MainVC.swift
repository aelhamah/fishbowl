//
//  MainVC.swift
//  swiftChatter
//
//  Created by Alex ElHamahmy on 9/7/21.
//

import UIKit

final class MainVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
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
