//
//  TabBar.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/16/21.
//

import Foundation
import SwiftUI

final class TabBar: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        self.selectedIndex = 1
    }
    
}
