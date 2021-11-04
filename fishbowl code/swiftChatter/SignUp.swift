//
//  Login.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI

final class SignUp: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var SigningIn: UIButton!
    
    @IBAction func GoToSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateProfilePage", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        username.layer.cornerRadius = 22
        password.layer.cornerRadius = 22
        SigningIn.layer.cornerRadius = 22
        
    }
}
