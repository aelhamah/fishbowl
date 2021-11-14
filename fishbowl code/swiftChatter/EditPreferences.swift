//
//  EditPreferences.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/14/21.
//

import SwiftUI

final class EditPreferences: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        ChangesButton.layer.cornerRadius = 22
    }
    
    @IBOutlet weak var ChangesButton: UIButton!
    
    
    @IBAction func WomenPreference(_ sender: Any) {
    }
    
    @IBAction func MenPreference(_ sender: Any) {
    }
    
    @IBAction func NonBinaryPreference(_ sender: Any) {
    }
    
    
    @IBAction func SeriousPreference(_ sender: Any) {
    }
    
    
    @IBAction func CasualPreference(_ sender: Any) {
    }
    
    @IBAction func SaveChanges(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoBackToPreferences", sender: self)
    }
    
    
}
