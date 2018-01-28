//
//  APIConnector.swift
//  Tyme
//
//  Created by elev on 20/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class APIConnector: API {
    
    public func PerformSearch(_ searchString : String, completion: @escaping ([StopLocation]?)->()) {
        let query : [String: String] = [
            "input" : searchString,
            "format" : "json"
        ]
        
        guard let url = URL(string: "\(base)/location")?.withQueries(query) else {
            completion(nil)
            return
        }
        print(url)
        
        contentsFrom(url: url) {
            (data) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let info = try? jsonDecoder.decode(SuperContainer.self, from: data)
                completion(info?.LocationList.list)
            } else {
                completion(nil)
            }
        }
    }
    
    private struct SuperContainer : Codable {
        public var LocationList : Container
    }
    
    private struct Container : Codable {
        public var list : [StopLocation]
        
        enum CodingKeys: String, CodingKey {
            case list = "StopLocation"
        }
    }
    
    public struct StopLocation : Codable, StopInfo{
        public var name : String
        public var id : String
        public var x : Int
        public var y : Int
        
        enum CodingKeys: String, CodingKey {
            case name
            case id
            case x
            case y
        }
        
        init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
            self.id = try valueContainer.decode(String.self, forKey: CodingKeys.id)
            self.x = Int(try valueContainer.decode(String.self, forKey: CodingKeys.x))!
            self.y = Int(try valueContainer.decode(String.self, forKey: CodingKeys.y))!
        }
    }
}
