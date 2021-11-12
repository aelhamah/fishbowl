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
    var matches = [Match]()
    private let nFields = Mirror(reflecting: Match()).children.count

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
    
    func getMatches(_ completion: ((Bool) -> ())?) {
            //guard let apiUrl = URL(string: serverUrl+"getmatches/?sender="+"3") else {
            print("in get matches")
            guard let apiUrl = URL(string: serverUrl+"getusers/?28") else {
                print("getmatches: Bad URL")
                return
            }
        

            var request = URLRequest(url: apiUrl)
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: request) { data, response, error in
                var success = false
                defer { completion?(success) }

                guard let data = data, error == nil else {
                    print("getMatches: NETWORKING ERROR")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("getMatches: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                }

                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("getMatches: failed JSON deserialization")
                    return
                }
                let matchesReceived = jsonObj["matches"] as? [[String?]] ?? []
                self.matches = [Match]()
                for matchEntry in matchesReceived {
                    if matchEntry.count == self.nFields {
                        self.matches.append(Match(imageUrl: matchEntry[0]
                                            ))
                       print("match appended")
                    } else {
                        print("getMatches: Received unexpected number of fields: \(matchEntry.count) instead of \(self.nFields).")
                    }
                }
                success = true // for completion(success)
            }.resume()
        }


}
