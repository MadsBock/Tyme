//
//  APIDetail.swift
//  Tyme
//
//  Created by elev on 20/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class APIDetail: API {
    public func currentDateFormatted() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd.MM.yy"
        return dateformat.string(from: Date())
    }
    
    public func GetDetails(id: String, completion: @escaping ([Details]?)->()) {
        let query : [String:String] = [
            "id" : id,
            "offsetTime" : "0",
            "date" : currentDateFormatted(),
            "format" : "json"
        ]
        
        let url = URL(string: "\(base)/departureBoard")?.withQueries(query)
        print(url)
        
        contentsFrom(url: url!) {
            (data) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let details = try? jsonDecoder.decode(SuperSuperDetails.self, from: data)
                completion(details?.DepartureBoard.Departure)
            } else {
                completion(nil)
            }
            
        }
    }
    
    class SuperSuperDetails : Codable {
        public var DepartureBoard : SuperDetails
    }
    
    class SuperDetails : Codable {
        public var Departure : [Details]
    }
    
    class Details : Codable {
        public var name : String
        public var time : String
        public var direction : String
        
        enum CodingKeys: String, CodingKey {
            case name
            case time
            case direction
        }
        
        required init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm"
            self.name = try valueContainer.decode(String.self, forKey: .name)
            self.time = try valueContainer.decode(String.self, forKey: .time)
            self.direction = try valueContainer.decode(String.self, forKey: .direction)
        }
    }
}
