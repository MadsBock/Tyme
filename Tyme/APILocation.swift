//
//  APILocation.swift
//  Tyme
//
//  Created by elev on 28/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit
import CoreLocation

class APILocation: API {
    func stopsNearby(location: CLLocation, completion: @escaping ([LocationStopInfo]?)->Void) {
        let lat = Int(location.coordinate.latitude * 1_000_000)
        let lon = Int(location.coordinate.longitude * 1_000_000)
        let urlString = "\(base)/stopsNearby"
        let query : [String:String] = [
            "coordX" : String(lon),
            "coordY" : String(lat),
            "maxRadius" : "1000",
            "maxNumber" : "20",
            "format" : "json"
        ]
        let url = URL(string: urlString)?.withQueries(query)
        print(url)
        contentsFrom(url: url!) {
            (data) in
            if let data = data {
                let decoder = JSONDecoder()
                completion(try? decoder.decode(Output.self, from: data).LocationList.StopLocation)
            }
        }
    }
    
    struct Output : Codable {
        var LocationList : Inner
        
        struct Inner : Codable {
            var StopLocation : [Location]
        }
        struct Location : LocationStopInfo, Codable {
            var name : String
            var id : String
            var distance : String
            var x : String
            var y : String
        }
    }
}
