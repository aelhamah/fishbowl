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
//        Gender.text = FishbowlStore.shared.fishies.;
        Sexuality.text = FishbowlStore.shared.fishies.GenderPreference;
        Relationship.text = FishbowlStore.shared.fishies.RelationshipPreference;
        Bio.text = FishbowlStore.shared.fishies.Bio; 
        
        print(FishbowlStore.shared.fishies)

        // setup refreshControler here later
    }


    @IBAction func LikeButton(_ sender: Any) {

    }


    @IBAction func RejectButton(_ sender: Any) {

    }


}
