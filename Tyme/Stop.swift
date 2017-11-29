//
//  Stop.swift
//  Tyme
//
//  Created by elev on 29/11/2017.
//  Copyright © 2017 Mads Bock. All rights reserved.
//

import UIKit

class Stop: NSObject {
    var name : String
    var detail : String?
    private var entries = [StopEntry]()
    
    
    public func set(entries: [StopEntry]) {
        self.entries = entries.sorted()
    }
    
    public func getEntries() -> [StopEntry] {
        return entries
    }
    
    init(_ name: String) {
        self.name = name
    }
}

class StopEntry : Comparable, CustomStringConvertible {
    var description: String {
        let h = String(format: "%2d", hours)
        let m = String(format: "%2d", minutes)
        return "\(h):\(m)"
    }
    
    static func <(lhs: StopEntry, rhs: StopEntry) -> Bool {
        if lhs.hours == rhs.hours {
            return lhs.minutes < rhs.minutes
        } else {
            return lhs.hours < rhs.minutes
        }
    }
    
    static func ==(lhs: StopEntry, rhs: StopEntry) -> Bool {
        return (lhs.hours == rhs.hours) && (lhs.minutes == rhs.minutes)
    }
    
    var line : String
    var hours : Int
    var minutes : Int
    
    init(line : String, hours : Int, minutes : Int) {
        self.line = line
        self.hours = hours
        self.minutes = minutes
    }
    
    
}
