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
    var users = [UserProfile]()
    var fishies = UserProfile()
    var matches = [Match]()
    private let nFields = Mirror(reflecting: Match()).children.count

    private let serverUrl = "http://3.15.21.206/"

//    func getProfile(user_list: [String], _ completion: ((Bool) -> ())?) -> [UserProfile]? {
//        guard let apiUrl = URL(string: serverUrl+"getusers/") else {
//            print("getProfile: bad URL")
//            return []
//        }
//        
//        let parameters: [String: String] = ["user_ids": "jenna@umich.edu"]
//        print(apiUrl)
//        AF.request(apiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
//            var success = false
//            defer { completion?(success) }
//            guard let data = response.data, response.error == nil else {
//                print("getProfile: NETWORKING ERROR")
//                return
//            }
//            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//                print("getProfile: failed JSON deserialization")
//                return
//            }
//        
//            let usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>>
//            self.users = [UserProfile]()
////            print(usersReceived?[1]["username"])
//            for (_, value) in usersReceived {
//                    print(value["bio"]!)
//                    print(value["username"]!)
//                self.users.append(UserProfile(Username: (value["username"] as! String), Bio: (value["bio"] as! String)))
//            }
//            success = true // for completion(success)
////            print(self.users)
//        }.resume()
//        return users
//    }
    
    func getProfile(id_token: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let apiUrl = URL(string: "http://3.15.21.206/"+"getusers/") else {
            print("getProfile: bad URL")
            print("Getting image with dummy image")
            // use dummy image
            let url = "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg"
            //            self.downloadImage(from: URL(string: url)!)
            return
        }
        let parameters: [String: String] = ["user_ids": id_token]
        print(apiUrl)
        var url = ""
        AF.request(apiUrl, method: .get, parameters: parameters,
                   encoding: URLEncoding.default).responseJSON { response in
            print(response)
            guard let data = response.data, response.error == nil else {
                print("getProfile: NETWORKING ERROR")
                completion(false)
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data)
                    as? [String: Any] else {
                        print("getProfile: failed JSON deserialization")
                        completion(false)
                        return
                    }
            var usersReceived: [String: [String: Any]] = [:]
            usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>> // swiftlint:disable:this force_cast
            if (usersReceived.count == 0) {
                return completion(false)
            }
            for (_, value) in usersReceived {
                print("Username", value["username"]!)
                print("DisplayName", value["display_name"]!)
                print("ImageURL", value["imageurl"]!)
                print("Email", value["email"]!)
                print("ID Token", value["token"]!)
                print("Gender pref", value["gender_preference"]!)
            }
            
            for (_, value) in usersReceived where value["token"] as? String == id_token  {// swiftlint:disable:this force_cast
                print(FishbowlStore.shared.users.count)
                for (index, val) in FishbowlStore.shared.users.enumerated() where val.Email == id_token {
                    FishbowlStore.shared.users[index].DisplayName = (value["display_name"] as? String)
                    
                    FishbowlStore.shared.users[index].Bio = (value["bio"] as? String)
                    FishbowlStore.shared.users[index].GenderPreference = (value["gender_preference"] as? String)
                    FishbowlStore.shared.users[index].RelationshipPreference = (value["relationship_preference"] as? String)
                    
                    
                    if value["imageurl"] != nil {
                        url = ((value["imageurl"] as? String)!)// swiftlint:disable:this force_cast
                        FishbowlStore.shared.users[index].imageUrl = url
                    }
                }
//                completion(true)
            }
        }
    }
    
//    func getProfile(user_list: [Int], _ completion: ((Bool) -> ())?) {
//        guard let apiUrl = URL(string: serverUrl+"getusers/") else {
//            print("getProfile: bad URL")
//            return
//        }
//        
//        let parameters: [String: String] = ["user_ids": "13"]
//        print(apiUrl)
//        AF.request(apiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
//            var success = false
//            defer { completion?(success) }
//            guard let data = response.data, response.error == nil else {
//                print("getProfile: NETWORKING ERROR")
//                return
//            }
//            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//                print("getProfile: failed JSON deserialization")
//                return
//            }
//        
//            let usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>>
//            self.users = [UserProfile]()
////            print(usersReceived?[1]["username"])
//            for (_, value) in usersReceived {
//                    print(value["username"]!)
//                    print(value["display_name"]!)
//                    print(value["imageurl"]!)
//                    print(value["email"]!)
//                    self.users.append(UserProfile(Username: (value["display_name"] as! String),
//                         Email: (value["email"] as! String),
//                         imageUrl: (value["imageurl"] as! String)))
//            }
//            success = true // for completion(success)
//        }.resume()
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
                    if let fishbowl_ID = user.FishBowlID?.data(using: .utf8) {
                        mpFD.append(fishbowl_ID, withName: "fishbowl_ID")
                    }
                    if let fullName = user.FullName?.data(using: .utf8) {
                        mpFD.append(fullName, withName: "fullName")
                    }
                    if let display_name = user.DisplayName?.data(using: .utf8) {
                        mpFD.append(display_name, withName: "display_name")
                    }
                    if let email = user.Email?.data(using: .utf8) {
                        mpFD.append(Fishbowl_ID.shared.email.data(using: .utf8)!, withName: "email")
                    }
                    if let bio = user.Bio?.data(using: .utf8) {
                        mpFD.append(bio, withName: "bio")
                    }
                    if let genderPreference = user.GenderPreference?.data(using: .utf8) {
                        mpFD.append(genderPreference, withName: "genderPreference")
                    }
                    if let relationshipPreference = user.RelationshipPreference?.data(using: .utf8) {
                        mpFD.append(relationshipPreference, withName: "relationshipPreference")
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
//
//    func getMatches(_ completion: ((Bool) -> ())?) {
//            //guard let apiUrl = URL(string: serverUrl+"getmatches/?sender="+"3") else {
//            print("in get matches")
//            guard let apiUrl = URL(string: serverUrl+"getusers/?28") else {
//                print("getmatches: Bad URL")
//                return
//            }
//
//
//            var request = URLRequest(url: apiUrl)
//            request.httpMethod = "GET"
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                var success = false
//                defer { completion?(success) }
//
//                guard let data = data, error == nil else {
//                    print("getMatches: NETWORKING ERROR")
//                    return
//                }
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    print("getMatches: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                }
//
//                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//                    print("getMatches: failed JSON deserialization")
//                    return
//                }
//                let matchesReceived = jsonObj["matches"] as? [[String?]] ?? []
//                self.matches = [Match]()
//                for matchEntry in matchesReceived {
//                    if matchEntry.count == self.nFields {
//                        self.matches.append(Match(imageUrl: matchEntry[0]
//                                            ))
//                       print("match appended")
//                    } else {
//                        print("getMatches: Received unexpected number of fields: \(matchEntry.count) instead of \(self.nFields).")
//                    }
//                }
//                success = true // for completion(success)
//            }.resume()
//        }
    func getMatches(_ completion: ((Bool) -> ())?) {
            print("in get matches")
        guard let apiUrl = URL(string: serverUrl+"getmatches/?sender="+"3") else {
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
                let matchesRecieved = jsonObj["matches"] as? [[String:Any]]

                self.matches = [Match]()
                for matchEntry in matchesRecieved ?? []{
                   // if matchEntry.count == self.nFields {
                    self.matches.append(Match(display_name:matchEntry["display_name"] as! String,
                                              imageUrl: matchEntry["imageurl"] as! String
                                              ))
                    print(self.matches)
                    print("match appended")
                       
//                    } else {
//                        //print("getMatches: Received unexpected number of fields: \(matchEntry.count) instead of \(self.nFields).")
//                        print("no")
//                    }
                }
                success = true
            }.resume()
        }

    
    func addUser(_ idToken: String?, completion: @escaping (String) -> Void) {
            guard let idToken = idToken else {
                completion("FAILED")
                return
            }
            
            let jsonObj = ["clientID": "896933683203-acnt9dg8im59p8m9tdhubr06qq45t2u5.apps.googleusercontent.com",
                        "idToken" : idToken]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("addUser: jsonData serialization error")
                completion("FAILED")
                return
            }

            guard let apiUrl = URL(string: serverUrl+"adduser/") else {
                print("addUser: Bad URL")
                completion("FAILED")
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let task =  URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("addUser: NETWORKING ERROR")
                    completion("FAILED")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("addUser: HTTP STATUS: \(httpStatus.statusCode)")
                    completion("FAILED")
                }
                
                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("addUser: failed JSON deserialization")
                    completion("FAILED")
                    return
                }
                
                Fishbowl_ID.shared.id = jsonObj["fishbowlID"] as? String ?? "DojaID"
                Fishbowl_ID.shared.expiration = Date()+(jsonObj["lifetime"] as! TimeInterval)
                Fishbowl_ID.shared.info = jsonObj["idinfo"] as! [String:Any]
                Fishbowl_ID.shared.email = Fishbowl_ID.shared.info["email"] as? String ?? "DojaEmail"
//                print(info["email"])
//                Fishbowl_ID.shared.info = jsonObj["idinfo"] as! [String:String]
                completion("OK")
            }
            task.resume()
        }
    
    
    func postauth(_ user: UserProfile) async {
            let jsonObj = ["fishbowlID": Fishbowl_ID.shared.id]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("postauth: jsonData serialization error")
                return
            }
                    
            guard let apiUrl = URL(string: serverUrl+"postauth/") else {
                print("postauth: Bad URL")
                return
            }
        
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            request.httpBody = jsonData

        do {
                    let (_, response) = try await URLSession.shared.data(for: request)

                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("postauth: HTTP STATUS: \(httpStatus.statusCode)")
                        return
                    }
                } catch {
                    print("postauth: NETWORKING ERROR")
                }
        }
    
}
