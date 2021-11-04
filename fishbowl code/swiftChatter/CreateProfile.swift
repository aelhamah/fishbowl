//
//  CreateProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI

final class CreateProfile: UIViewController {

   
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Birthday: UITextField!
    @IBOutlet weak var Bio: UITextField!
    
    
    
    @IBAction func SignUpComplete(_ sender: Any) {
        
        FishbowlStore.shared.createUserProfile(UserProfile(FullName: LastName.text, DisplayName: FirstName.text, Email: Email.text, Birthday: Birthday.text, Bio: Bio.text))

        
        self.performSegue(withIdentifier: "SignUpToLandingScreen", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
    }
}
