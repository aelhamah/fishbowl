//
//  MyCell1.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 11/17/21.
//

import Foundation

class MyCell1 : GenericCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("MyCell1 Initialization Done")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
