//
//  Extensions.swift
//  swiftChatter
//
//  Created by Alex ElHamahmy on 11/3/21.
//

import UIKit

extension UILabel {
    convenience init(useMask: Bool, font: UIFont = UIFont.systemFont(ofSize: 17.0), fontSize: CGFloat = 17.0, text: String? = nil, lines: Int = 0, linebreak: NSLineBreakMode = .byWordWrapping) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = useMask
        self.font = font.withSize(fontSize)
        self.text = text
        numberOfLines = lines
        lineBreakMode = linebreak
    }
}

extension UITextView {
    convenience init(useMask: Bool, font: UIFont = UIFont.systemFont(ofSize: 17.0), text: String? = nil) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = useMask
        self.font = font
        self.text = text
    }
}
