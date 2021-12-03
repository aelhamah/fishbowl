//
//  signUpFailure.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/21/21.
//

import SwiftUI

class signUpFailure: UIViewController {
    

    @IBOutlet weak var actuallySignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        actuallySignUp.layer.cornerRadius = 22
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signUpFailureToCreateProfile", sender: self)
    }
}

