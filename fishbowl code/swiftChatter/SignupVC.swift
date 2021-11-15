//
//  SignupVC.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/13/21.
//

import Foundation
import SwiftUI
import GoogleSignIn
// TODO2.1: Declare the ReturnDelegate protocol as in lab1

final class SignupVC: UIViewController, GIDSignInDelegate {
    // TODO2.2: declare the returnDelegate variable for the delegatee to register itself
    private let store = FishbowlStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let signin = GIDSignIn.sharedInstance() else {
                    // TODO3.1: return "FAILED" to delegate class PostVC
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                
                // set SigninVC as the delegate for GIDSignIn.sharedInstance()
                signin.delegate = self
        if let user = signin.currentUser {
                    user.authentication.getTokensWithHandler(didRefreshTokens)
        } else {
                    signin.presentingViewController = self
                    
                    // Automatically sign in the user if not previously signed in,
                    // which triggers the sign(_:didSignInFor:withError:) delegate/handler
                    signin.restorePreviousSignIn()
                }
    }
    
    func didRefreshTokens(auth: GIDAuthentication?, error: Error?) {
            if let _ = error {
                // TODO3.2: return "FAILED" to delegate class PostVC
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            store.addUser(auth?.idToken) { result in
                // TODO3.3: return result (argument to this closure) to the delegate
                // class, PostVC
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                    // No previous signIn could be restored
                    // Add a Google Sign-in button centered on your screen
                    // When user clicks on button, this function will be called a second time
                    let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
                    signInButton.center = view.center
                    view.addSubview(signInButton)
                } else {
                    // unknown error
                    print("sign(didSignInFor:): \(error.localizedDescription)")
                    // TODO3.4: return "FAILED" to delegate class PostVC
                    self.dismiss(animated: true, completion: nil)
                }
                return // function will be called again after second signin completion,
                       // so don't dismiss if there's no unknown error
            } else {
                        // when called second time should end up here or unknown error above
                        store.addUser(user?.authentication.idToken) { result in
                            // TODO3.5: return result (arg to this closure) to the delegate
                            // class, PostVC
                            DispatchQueue.main.async {
//                                self.dismiss(animated: true, completion: nil)
                              
//                                var window: UIWindow?
//                                guard let scene = (scene as? UIWindowScene) else { return }
//
//                                let window = UIWindow(windowScene: scene)
//                                window.rootViewController = UINavigationController(rootViewController: JoinViewController())
//                                self.window = window
//
//                                window.makeKeyAndVisible()

//                                self.performSegue(withIdentifier: "GoogleSuccessSignup", sender: self)
                            }
                            
                        }
                    }
                }
                
    
    
}
