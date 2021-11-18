//
//  CreateProfile.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import SwiftUI

final class CreateProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var profilePicUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        ScrollView.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height+100)
    }
   
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var postProfilePicture: UIImageView!
    
    @IBAction func pickMedia(_ sender: Any) {
        presentPicker(.photoLibrary)
    }
    
    @IBAction func accessCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentPicker(.camera)
        } else {
            print("Camera not available. iPhone simulators don't simulate the camera.")
        }

    }
    
    private func presentPicker(_ sourceType: UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.mediaTypes = ["public.image"]
            present(imagePickerController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType  == "public.image" {
                    postProfilePicture.image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                                        info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?
                        .resizeImage(targetSize: CGSize(width: 150, height: 181))
                }
            }
                    picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Bio: UITextField!
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var GenderPreference: UITextField!
    
  //  @IBOutlet weak var genderPreferenceDropdown: UIPickerView!
    @IBOutlet weak var RelationshipPreference: UITextField!
    
    var interest = ""
    var looking_for = ""
    var identify = ""
    var interestMen = false
    var interestWomen = false
    var interestBoth = false
    var casualbool = false
    var seriousbool = false
    var identifyMale = false
    var identifyFemale = false
    var identifyNonBinary = false
    
    
    
    @IBAction func interestMen(_ sender: UIButton) {
        interest = "men"

        
        sender.tintColor = UIColor.systemPink
        
      
      
        
//
        
//        var manButton = sender as UIButton
//        dispatch_async(dispatch_get_main_queue()) {
//            self.memberButton.highlighted = manButton == self.memberButton
//            self.signUpButton.highlighted = manButton == self.signUpButton
//        }
        
    
        
        
        print(interest)
    }
    
    @IBAction func interestWomen(_ sender: UIButton) {
        interest = "women"
        interestMen = false
        interestWomen = true
        interestBoth = false
        
        sender.tintColor = UIColor.systemPink
 
        //print(interest)
    }
    
    @IBAction func interestBoth(_ sender: UIButton) {
        interest = "both"
    
        interestMen = false
        interestWomen = false
        interestBoth = true
        
        sender.tintColor = UIColor.systemPink

        //print(interest)
    }
    
    
    @IBAction func casual(_ sender: UIButton) {
        looking_for = "casual"
        sender.tintColor = UIColor.systemPink
        //print(looking_for)
    }
    
    @IBAction func serious(_ sender: UIButton) {
        looking_for = "serious"
        sender.tintColor = UIColor.systemPink
        //print(looking_for)
    }
    
    
    @IBAction func identifyMale(_ sender: UIButton) {
        identify = "male"
        sender.tintColor = UIColor.systemPink
        //print(identify)
    }
    
    @IBAction func identifyFemale(_ sender: UIButton) {
        identify = "female"
        sender.tintColor = UIColor.systemPink
        //print(identify)
    }
    
    @IBAction func non_binary(_ sender: UIButton) {
        identify = "non-binary"
        sender.tintColor = UIColor.systemPink
        //print(identify)
    }
    @IBAction func SignUpComplete(_ sender: Any) {
        
        let user = UserProfile(FishBowlID: Fishbowl_ID.shared.id,
                               Username: Username.text,
                               FullName: LastName.text,
                               DisplayName: FirstName.text,
                               Email: Email.text,
                               Bio: Bio.text,
                               GenderPreference: interest,
                               RelationshipPreference: looking_for,
                               imageUrl: nil)
        
        FishbowlStore.shared.createUserProfile(user, image: postProfilePicture.image) 
        
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        
    }
    
}
