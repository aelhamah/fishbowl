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


    @IBOutlet weak var relationshipPreferenceSerious: UIButton!
    @IBOutlet weak var relationshipPreferenceCasual: UIButton!
    @IBOutlet weak var genderPreferenceBoth: UIButton!
    @IBOutlet weak var genderPreferenceMen: UIButton!
    @IBOutlet weak var genderPreferenceWomen: UIButton!
    var genderPreferenceChange = ""
    var relationshipPreferenceChange = ""

    @IBOutlet weak var ChangesButton: UIButton!

    @IBAction func IntWomen(_ sender: Any) {
        genderPreferenceChange = "female"
        genderPreferenceMen.tintColor = UIColor.blue
        genderPreferenceWomen.tintColor = UIColor.systemPink
        genderPreferenceBoth.tintColor = UIColor.blue
        
        Fishbowl_ID.shared.genderPreference = genderPreferenceChange
    }

    @IBAction func IntMen(_ sender: Any) {
        genderPreferenceChange = "male"
        genderPreferenceMen.tintColor = UIColor.systemPink
        genderPreferenceWomen.tintColor = UIColor.blue
        genderPreferenceBoth.tintColor = UIColor.blue
        Fishbowl_ID.shared.genderPreference = genderPreferenceChange
    }

    @IBAction func IntBoth(_ sender: Any) {
        genderPreferenceChange = "both"
        genderPreferenceMen.tintColor = UIColor.blue
        genderPreferenceWomen.tintColor = UIColor.blue
        genderPreferenceBoth.tintColor = UIColor.systemPink
        Fishbowl_ID.shared.genderPreference = genderPreferenceChange
    }

    @IBAction func IntCasual(_ sender: Any) {
        relationshipPreferenceChange = "casual"
        relationshipPreferenceCasual.tintColor = UIColor.systemPink
        relationshipPreferenceSerious.tintColor = UIColor.blue
        Fishbowl_ID.shared.relationshipPreference = relationshipPreferenceChange
    }

    @IBAction func IntSerious(_ sender: Any) {
        relationshipPreferenceChange = "serious"
        relationshipPreferenceCasual.tintColor = UIColor.blue
        relationshipPreferenceSerious.tintColor = UIColor.systemPink
        
        Fishbowl_ID.shared.relationshipPreference = relationshipPreferenceChange
    }

    @IBAction func SaveChanges(_ sender: Any) {

        print(Fishbowl_ID.shared.id)
            let user = UserProfile(FishBowlID: Fishbowl_ID.shared.id,
                                   Email: Fishbowl_ID.shared.email,
                                   GenderPreference: Fishbowl_ID.shared.genderPreference,
                                   RelationshipPreference: Fishbowl_ID.shared.relationshipPreference
            )
//        call createusers api to update everything
            FishbowlStore.shared.createUserProfile(user, image: nil)


        self.performSegue(withIdentifier: "GoBackToPreferences", sender: self)
        // call post
    }
    
    
    @IBAction func cancelEdit(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoBackToPreferences", sender: self)
    }
    

//}
}
