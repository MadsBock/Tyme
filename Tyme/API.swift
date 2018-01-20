//
//  API.swift
//  Tyme
//
//  Created by elev on 20/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class API: NSObject {
    public let base = "https://xmlopen.rejseplanen.dk/bin/rest.exe"
    
    public func contentsFrom(url : URL, completion: @escaping (Data?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data)
        }
        task.resume()
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
