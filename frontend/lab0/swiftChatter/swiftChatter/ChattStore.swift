//
//  ChattStore.swift
//  swiftChatter
//
//  Created by Alex ElHamahmy on 9/7/21.
//

import Foundation

final class ChattStore {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://18.222.253.25/"
    
    func postChatt(_ chatt: Chatt) {
        let jsonObj = ["username": chatt.username,
                       "message": chatt.message]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: serverUrl+"postchatt/") else {
            print("postChatt: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postChatt: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
        }.resume()
    }
    
    func getChatts(_ completion: ((Bool) -> ())?) {
        guard let apiUrl = URL(string: serverUrl+"getchatts/") else {
            print("getChatts: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            var success = false
            defer { completion?(success) }
            
            guard let data = data, error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
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
                if chattEntry.count == self.nFields {
                    self.chatts.append(Chatt(username: chattEntry[0],
                                        message: chattEntry[1],
                                        timestamp: chattEntry[2]))
                } else {
                    print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
            success = true // for completion(success)
        }.resume()
    }
}


