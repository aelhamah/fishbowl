//
//  ChatTableCell.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import Foundation
import UIKit

final class ChattTableCell: UITableViewCell {

    let usernameLabel = UILabel(useMask: false)
    let timestampLabel = UILabel(useMask: false)
    let messageLabel = UILabel(useMask: false)
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(usernameLabel)
            contentView.addSubview(timestampLabel)
            contentView.addSubview(messageLabel)

            let lmg = contentView.layoutMarginsGuide
            NSLayoutConstraint.activate([
                usernameLabel.topAnchor.constraint(equalTo: lmg.topAnchor),
                usernameLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                
                timestampLabel.topAnchor.constraint(equalTo: lmg.topAnchor),
                timestampLabel.trailingAnchor.constraint(equalTo: lmg.trailingAnchor),
                
                messageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
                messageLabel.leadingAnchor.constraint(equalTo: lmg.leadingAnchor),
                messageLabel.widthAnchor.constraint(equalTo: lmg.widthAnchor),

                lmg.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) view deserialization not supported")
        }
    
    
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
