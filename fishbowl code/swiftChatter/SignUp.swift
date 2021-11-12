//
//  Login.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

final class SignUp: UIViewController, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("signed in")
     
    }
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var SigningIn: UIButton!
    
    @IBAction func GoToSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateProfilePage", sender: self)
        
    }
    
    @IBAction func googleSignInClicked(sender: UIButton) {
            GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        print("signed in")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
    
        username.layer.cornerRadius = 22
        password.layer.cornerRadius = 22
        SigningIn.layer.cornerRadius = 22
        
    }
}
