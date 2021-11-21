//
//  ProfilePage.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 10/28/21.
//

import SwiftUI
import UIKit
import MessageKit
import InputBarAccessoryView
import AVKit
import SDWebImage

class ProfilePage: UIViewController {


    @IBOutlet weak var FishiesPicture: UIImageView!
    @IBOutlet weak var DisplayName: UILabel!
    @IBOutlet weak var Gender: UILabel!
    @IBOutlet weak var Sexuality: UILabel!
    @IBOutlet weak var Relationship: UILabel!
    @IBOutlet weak var Bio: UITextView!
    
    @IBAction func blockUser(_ sender: Any) {
        let senderEmail = Fishbowl_ID.shared.email
        FishbowlStore.shared.blockUser(senderEmail, FishbowlStore.shared.fishies.Actual_Email ?? "error")
        self.performSegue(withIdentifier: "blockReturn", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = FishbowlStore.shared.fishies.imageUrl, let imageUrl = URL(string: urlString) {
                    FishiesPicture.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: [.progressiveLoad])
                    FishiesPicture.isHidden = false
                } else {
                    FishiesPicture.image = nil
                    FishiesPicture.isHidden = true
                }
        
        DisplayName.text = FishbowlStore.shared.fishies.DisplayName;
        Gender.text = FishbowlStore.shared.fishies.GenderIdentity;
        Sexuality.text = FishbowlStore.shared.fishies.GenderPreference;
        Relationship.text = FishbowlStore.shared.fishies.RelationshipPreference;
        Bio.text = FishbowlStore.shared.fishies.Bio; 
        
        print(FishbowlStore.shared.fishies)

        // setup refreshControler here later
    }


    @IBAction func LikeButton(_ sender: Any) {
        
        FishbowlStore.shared.likeUser(Fishbowl_ID.shared.email, FishbowlStore.shared.fishies.Actual_Email ?? "nil")
        print(Fishbowl_ID.shared.email)
        print(FishbowlStore.shared.fishies)
        print(FishbowlStore.shared.fishies.Actual_Email)
        print("sanity")
        if FishbowlStore.shared.successful_match {
            FishbowlStore.shared.successful_match = false
            self.performSegue(withIdentifier: "itsAMatch", sender: self)
        }
    }


    @IBAction func RejectButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "RejectUserSegue", sender: self)

    }


}
