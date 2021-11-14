//
//  EditBio.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/14/21.
//
import SwiftUI

final class EditBio: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        ChangesButton.layer.cornerRadius = 22
    }
    
    @IBOutlet weak var ChangesButton: UIButton!
    @IBOutlet weak var NewBiography: UITextField!
    
    
    @IBAction func MaleSelected(_ sender: Any) {
    }
    
    @IBAction func FemaleSelected(_ sender: Any) {
    }
    
    
    @IBAction func NonBinarySelected(_ sender: Any) {
    }
    
    @IBAction func SaveUserChanges(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoBackToPreferences", sender: self)
    }
    
    
}

