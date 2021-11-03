//
//  ViewController.swift
//  swiftChatter
//
//  Created by Alex ElHamahmy on 9/7/21.
//

import UIKit

final class PostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBAction func submitChatt(_ sender: UIBarButtonItem) {
        ChattStore.shared.postChatt(Chatt(username: usernameLabel.text,
                                             message: messageTextView.text))

        dismiss(animated: true, completion: nil)
    }
}

