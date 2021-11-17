//
//  UserPreferences.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/14/21.
//

import SwiftUI

final class UserPreferences: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var profilePicUrl: URL?

    @IBOutlet weak var LookAtBlocked: UIButton!
    @IBOutlet weak var BioButton: UIButton!
    @IBOutlet weak var PreferencesButton: UIButton!
    
    @IBOutlet weak var newProfilePicture: UIImageView!
    
    @IBOutlet weak var relationshipPreference: UILabel!
    @IBOutlet weak var genderPreference: UILabel!
    
    @IBOutlet weak var bio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.isModalInPresentation = true;
        self.hideKeyboardWhenTappedAround()
        newProfilePicture.setRounded()
        LookAtBlocked.layer.cornerRadius = 22
        BioButton.layer.cornerRadius = 22
        PreferencesButton.layer.cornerRadius = 22
        
        var user_list = ["change this later"]
        var user = FishbowlStore.shared.getProfile(user_list: user_list) { success in
                       DispatchQueue.main.async {
                           print("reached here")
                           if success {
                               print("suceeded")
                               self.genderPreference.text = "Men"
                               self.relationshipPreference.text = "Casual"
                           }
                       }
                   }
    }
    

    @IBAction func GoToBlockedUsers(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToBlockedUsers", sender: self)
    }
    
    @IBAction func GoToEditBio(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToEditBio", sender: self)
    }
    
    @IBAction func GoToEditPreferences(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToEditPreferences", sender: self)
    }
    
    @IBAction func pickPhotoLibrary(_ sender: Any) {
        presentPicker(.photoLibrary)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
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
                    newProfilePicture.image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage ??
                                        info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?
                        .resizeImage(targetSize: CGSize(width: 150, height: 181))
                }
            }
                    picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

