//
//  BlockedUsers.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/14/21.
//

import SwiftUI

final class BlockedUsers: UITableViewController {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        
        //    guard let _ = Fishbowl_ID.shared.id else {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        // TODO4: programmatically instantiate SigninVC and present
        //        // it.  SigninVC will be returning data using the same
        //        // ReturnDelegate protocol we used in lab1, so you need to
        //        // set it up prior to presenting SigninVC.
        //        return
        //    }
            // MARK:- TableView handlers

        //       override func numberOfSections(in tableView: UITableView) -> Int {
        //           // how many sections are in table
        //           return 1
        //       }
        //
        //       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //           // how many rows per section
        //           return ChattStore.shared.chatts.count
        //       }
        //
        //       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //           // event handler when a cell is tapped
        //           tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //       }
        //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            // populate a single cell
        //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChattTableCell", for: indexPath) as? ChattTableCell else {
        //                fatalError("No reusable cell!")
        //            }
        //
        //            let chatt = ChattStore.shared.chatts[indexPath.row]
        //            cell.backgroundColor = (indexPath.row % 2 == 0) ? .systemGray5 : .systemGray6
        //            cell.usernameLabel.text = chatt.username
        ////            cell.messageLabel.text = chatt.message
        //            cell.timestampLabel.text = chatt.timestamp



        //            if let urlString = chatt.imageUrl, let imageUrl = URL(string: urlString) {
        //                cell.chattImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
        //                cell.chattImageView.isHidden = false
        //            } else {
        //                cell.chattImageView.image = nil
        //                cell.chattImageView.isHidden = true
        //            }

        //            if let urlString = chatt.videoUrl, let videoUrl = URL(string: urlString) {
        //                cell.videoButton.isHidden = false // remember: cells are recycled and reused
        //                cell.playVideo = {
        //                    let avPlayerVC = AVPlayerViewController()
        //                    avPlayerVC.player = AVPlayer(url: videoUrl)
        //                    if let player = avPlayerVC.player {
        //                        self.present(avPlayerVC, animated: true) {
        //                            player.play()
        //                        }
        //                    }
        //                }
        //            } else {
        //                cell.videoButton.isHidden = true
        //                cell.playVideo = nil
        //            }

        //            return cell
        //        }

        //    private func refreshTimeline(_ sender: UIAction?) {
        //           ChattStore.shared.getChatts { success in
        //               DispatchQueue.main.async {
        //                   if success {
        //                       self.tableView.reloadData()
        //                   }
        //                   // stop the refreshing animation upon completion:
        //                   self.refreshControl?.endRefreshing()
        //               }
        //           }
        //       }
    }
    
    
    
    
    
}
