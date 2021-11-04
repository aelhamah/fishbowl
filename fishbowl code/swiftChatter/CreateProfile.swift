//
//  CreateProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI

final class CreateProfile: UIViewController {

    @IBAction func SignUpComplete(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SignUpToLandingScreen", sender: self)
        
    }
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var Birthday: UITextField!
    @IBOutlet weak var Bio: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup refreshControler here later
    }
}
