//
//  FishbowlStore.swift
//  swiftChatter
//
//  Created by Nicole Iannaci on 11/4/21.
//

import Foundation
import UIKit
import Alamofire

final class FishbowlStore {
    static let shared = FishbowlStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    //var chatts = [Chatt]()
    //private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "http://3.15.21.206/"
    
//    func postChatt(_ chatt: Chatt) {
//            let jsonObj = ["username": chatt.username,
//                           "message": chatt.message]
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
//                print("postChatt: jsonData serialization error")
//                return
//            }
//
//            guard let apiUrl = URL(string: serverUrl+"postchatt/") else {
//                print("postChatt: Bad URL")
//                return
//            }
//
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let _ = data, error == nil else {
//                    print("postChatt: NETWORKING ERROR")
//                    return
//                }
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                }
//            }.resume()
//    }
    
    func createUserProfile(_ user: UserProfile, image: UIImage?) {
        
        
        guard let apiUrl = URL(string: serverUrl+"createusers/") else {
                    print("createUserProfile: Bad URL")
                    return
                }
                
                AF.upload(multipartFormData: { mpFD in
                    if let username = user.Username?.data(using: .utf8) {
                        mpFD.append(username, withName: "username")
                    }
                    if let fullName = user.FullName?.data(using: .utf8) {
                        mpFD.append(fullName, withName: "fullName")
                    }
                    if let display_name = user.DisplayName?.data(using: .utf8) {
                        mpFD.append(display_name, withName: "display_name")
                    }
                    if let email = user.Email?.data(using: .utf8) {
                        mpFD.append(email, withName: "email")
                    }
                    if let bio = user.Bio?.data(using: .utf8) {
                        mpFD.append(bio, withName: "bio")
                    }
                    if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                        mpFD.append(jpegImage, withName: "image", fileName: "profileImage", mimeType: "image/jpeg")
                    }
                    
                }, to: apiUrl, method: .post).response { response in
                    switch (response.result) {
                    case .success:
                        print("createUserProfile: profile created!")
                    case .failure:
                        print("createUserProfile: profile creation failed")
                    }
            }
        
        
        
        
//        let jsonObj = ["fullName": user.FullName,
//                       "display_name": user.DisplayName,
//                       "email": user.Email,
//                       "bio": user.Bio]
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
//                print("createUserProfile: jsonData serialization error")
//                return
//            }
//
//            guard let apiUrl = URL(string: serverUrl+"createusers/") else {
//                print("createUserProfile: Bad URL")
//                return
//            }
//
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let _ = data, error == nil else {
//                    print("createUserProfile: NETWORKING ERROR")
//                    return
//                }
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    print("createUserProfile: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                }
//
//            }.resume()
    }
    
//    func getChatts(_ completion: ((Bool) -> ())?) {
//            guard let apiUrl = URL(string: serverUrl+"getchatts/") else {
//                print("getChatts: Bad URL")
//                return
//            }
//
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "GET"
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                var success = false
//                defer { completion?(success) }
//
//                guard let data = data, error == nil else {
//                    print("getChatts: NETWORKING ERROR")
//                    return
//                }
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                }
//
//                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//                    print("getChatts: failed JSON deserialization")
//                    return
//                }
//                let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
//                self.chatts = [Chatt]()
//                for chattEntry in chattsReceived {
//                    if chattEntry.count == self.nFields {
//                        self.chatts.append(Chatt(username: chattEntry[0],
//                                            message: chattEntry[1],
//                                            timestamp: chattEntry[2]))
//                    } else {
//                        print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
//                    }
//                }
//                success = true // for completion(success)
//            }.resume()
//        }
//

}
