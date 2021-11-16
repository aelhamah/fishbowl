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
    
    @IBOutlet weak var RelationshipPreference: UITextField!
    @IBAction func SignUpComplete(_ sender: Any) {
        
        let user = UserProfile(FishBowlID: Fishbowl_ID.shared.id,
                               Username: Username.text,
                               FullName: LastName.text,
                               DisplayName: FirstName.text,
                               Email: Email.text,
                               Bio: Bio.text,
                               GenderPreference: GenderPreference.text,
                               RelationshipPreference: RelationshipPreference.text,
                               imageUrl: nil)
        
        FishbowlStore.shared.createUserProfile(user, image: postProfilePicture.image) 
        
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        
    }
    
}
