//
//  ChatTableCell.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import Foundation
import UIKit

final class ChattTableCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chattImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
//    @IBAction func videoTapped(_ sender: Any) {
//        self.playVideo?()
//    }
    
    @IBAction func videoTapped(_ sender: UIButton) {
        self.playVideo?()
    }
    
    var playVideo: (() -> Void)?  // a closure
    
}
