//
//  ChattStore.swift
//  swiftChatter
//
//  Created by Rithika Ganesh on 9/7/21.
//

import Foundation
import Alamofire

final class ChattStore {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://3.135.185.107/"
    
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
    
    func getChatts(_ completion: ((Bool) -> ())?) {
            guard let apiUrl = URL(string: serverUrl+"getimages/") else {
                print("getChatts: bad URL")
                return
            }
            
            AF.request(apiUrl, method: .get).responseJSON { response in
                var success = false
                defer { completion?(success) }
                
                guard let data = response.data, response.error == nil else {
                    print("getChatts: NETWORKING ERROR")
                    return
                }
                if let httpStatus = response.response, httpStatus.statusCode != 200 {
                    print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                }
                
                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("getChatts: failed JSON deserialization")
                    return
                }
                let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
                self.chatts = [Chatt]()
                for chattEntry in chattsReceived {
                    if (chattEntry.count == self.nFields) {
                        self.chatts.append(Chatt(username: chattEntry[0],
                                         message: chattEntry[1],
                                         distance: chattEntry[2],
                                         imageUrl: chattEntry[3],
                                         videoUrl: chattEntry[4]))
                    } else {
                        print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                    }
                }
                success = true // for completion(success)
            }
        }
}

