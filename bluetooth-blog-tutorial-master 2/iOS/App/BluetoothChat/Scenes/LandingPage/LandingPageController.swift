//
//  LandingPageController.swift
//  BluetoothChat
//
//  Created by Rithika Ganesh on 11/3/21.
//  Copyright © 2021 DittoLive Incorporated. All rights reserved.
//

import UIKit

struct User {
    var id: String
    var name: String
    var email: String
    var distance: Double
}

class LandingPageController: UITableViewController {

    let users = [
        User(id: "rithikag", name: "rithika", email:"rithikag@umich.edu", distance:5.0),
]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

            let user = users[indexPath.row]
    cell.textLabel?.text = user.name

            return cell
        }
    // MARK: - Table view data source

}
