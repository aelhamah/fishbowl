//
//  ChattStore.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import Foundation
import Alamofire
import SwiftUI

final class FishbowlStore {
    static let shared = FishbowlStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    var users = [User]()
    private let nFields = Mirror(reflecting: User()).children.count
    
    // fishbowl url
    private let serverUrl = "http://3.22.41.185/"
    
    func postChatt(_ chatt: Chatt, image: UIImage?) {
            guard let apiUrl = URL(string: serverUrl+"postimages/") else {
                print("postChatt: Bad URL")
                return
            }
            
            AF.upload(multipartFormData: { mpFD in
                if let username = chatt.username?.data(using: .utf8) {
                    mpFD.append(username, withName: "username")
                }
                if let message = chatt.message?.data(using: .utf8) {
                    mpFD.append(message, withName: "message")
                }
                if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                    mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
                }
                if let urlString = chatt.videoUrl, let videoUrl = URL(string: urlString) {
                    mpFD.append(videoUrl, withName: "video", fileName: "chattVideo", mimeType: "video/mp4")
                }
            }, to: apiUrl, method: .post).response { response in
                switch (response.result) {
                case .success:
                    print("postChatt: chatt posted!")
                case .failure:
                    print("postChatt: posting failed")
                }
            }
        }
    
    func getProfile(_ user_list: [Int]) {
        guard let apiUrl = URL(string: serverUrl+"getusers/") else {
            print("getProfile: bad URL")
            return
        }
        
        let parameters: [String: String] = ["user_ids": "1,2"]
        print(apiUrl)
        AF.request(apiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            guard let data = response.data, response.error == nil else {
                print("getProfile: NETWORKING ERROR")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getProfile: failed JSON deserialization")
                return
            }
        
            let usersReceived = jsonObj["users"] as! Dictionary<String, Dictionary<String, Any>>
            self.users = [User]()
//            print(usersReceived?[1]["username"])
            for (_, value) in usersReceived {
                    print(value["username"]!)
                    print(value["display_name"]!)
                    self.users.append(User(username: (value["display_name"] as! String)))
                }
        }
    }
    
//    func getProfile(_ completion: ((Bool) -> ())?) {
//            guard let apiUrl = URL(string: serverUrl+"getimages/") else {
//                print("getProfile: bad URL")
//                return
//            }
//
//            AF.request(apiUrl, method: .get).responseJSON { response in
//                var success = false
//                defer { completion?(success) }
//
//                guard let data = response.data, response.error == nil else {
//                    print("getProfile: NETWORKING ERROR")
//                    return
//                }
//                if let httpStatus = response.response, httpStatus.statusCode != 200 {
//                    print("getProfile: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                }
//
//                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//                    print("getProfile: failed JSON deserialization")
//                    return
//                }
//                let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
//                self.chatts = [Chatt]()
//                for chattEntry in chattsReceived {
//                    if (chattEntry.count == self.nFields) {
//                        self.chatts.append(Chatt(username: chattEntry[0],
//                                         message: chattEntry[1],
//                                         imageUrl: chattEntry[2],
//                                         videoUrl: chattEntry[3]))
//                    } else {
//                        print("getProfile: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
//                    }
//                }
//                success = true // for completion(success)
//            }
//        }
}
