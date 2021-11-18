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

class ProfilePage: UIViewController {
    
    
    @IBOutlet weak var FishiesPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FishiesPicture.imageFromUrl(urlString: FishbowlStore.shared.fishies.imageUrl!)
        
        print(FishbowlStore.shared.fishies)
        
        // setup refreshControler here later
    }
    
    
    @IBAction func LikeButton(_ sender: Any) {
        
    }
    
    
    @IBAction func RejectButton(_ sender: Any) {
        
    }
    
    
}
