//
//  Login.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI

final class LoginORSignUp: UIViewController {
    
    @IBOutlet weak var SigningIn: UIButton!
    @IBOutlet weak var SigningUp: UIButton!
    
    @IBAction func GoToSignUp(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "GoogleSignup", sender: self)
        
    }
    
    @IBAction func SignInButton(_ sender: Any) {
        
//        FishbowlStore.shared.postauth(UserProfile)
        
        self.performSegue(withIdentifier: "GoToGoogleSignIn", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SigningIn.layer.cornerRadius = 22
        SigningUp.layer.cornerRadius = 22
        
    }
}
