//
//  GenericCell.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 11/17/21.
//

import Foundation
class GenericCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Generic Cell Initialization Done")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
