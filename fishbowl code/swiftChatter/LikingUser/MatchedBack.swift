//
//  MatchedBack.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/19/21.
//

import SwiftUI
import UIKit
import MessageKit
import InputBarAccessoryView
import AVKit
import SDWebImage

class MatchBack: UIViewController {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Sexuality: UITextField!
    @IBOutlet weak var Relationship: UITextField!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var itsAMatch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itsAMatch.setRounded()
        
        if let urlString = FishbowlStore.shared.fishies.imageUrl, let imageUrl = URL(string: urlString) {
                    ProfilePic.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
                    ProfilePic.isHidden = false
                } else {
                    ProfilePic.image = nil
                    ProfilePic.isHidden = true
                }
        
        Name.text = FishbowlStore.shared.fishies.DisplayName;
        Gender.text = FishbowlStore.shared.fishies.GenderIdentity;
        Sexuality.text = FishbowlStore.shared.fishies.GenderPreference;
        Relationship.text = FishbowlStore.shared.fishies.RelationshipPreference;
        Bio.text = FishbowlStore.shared.fishies.Bio;
        
        print(FishbowlStore.shared.fishies)

        // setup refreshControler here later
    }
    
    
    @IBAction func messageMatch(_ sender: Any) {
        
    }
    
    @IBAction func backToDash(_ sender: Any) {
        self.performSegue(withIdentifier: "backToDash", sender: self)
    }
    
}
