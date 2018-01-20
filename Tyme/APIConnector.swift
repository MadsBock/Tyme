//
//  APIConnector.swift
//  Tyme
//
//  Created by elev on 20/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class APIConnector: NSObject {
    private let base = "https://xmlopen.rejseplanen.dk/bin/rest.exe"
    
    public func PerformSearch(_ searchString : String, completion: (SearchResult?)->Void) {
        let query : [String: String] = [
            "input" : searchString,
            "format" : "json"
        ]
        
        guard let url = URL(string: "\(base)/location")?.withQueries(query) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print(string)
            }
        }
        print(url.absoluteString)
        task.resume()
    }
    
    struct SearchResult {
        public var test : String
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
