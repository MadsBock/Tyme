//
//  FavouritesController.swift
//  Tyme
//
//  Created by elev on 21/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class FavouritesController: NSObject {
    public static let instance = FavouritesController()
    
    public var favourites : [String:Favourite] = [:]
    
    private override init() {
        super.init()
        LoadData()
    }
    
    @objc(_TtCC4Tyme20FavouritesController9Favourite)class Favourite : NSObject, NSCoding, StopInfo {
        public var name : String
        public var id : String
        public var main : Bool
        
        init(name:String, id:String, main:Bool) {
            self.name = name
            self.id = id
            self.main = main
        }
        
        required convenience init?(coder aDecoder: NSCoder) {
            guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
                print("Error, name could not be loaded")
                return nil
            }
            guard let id = aDecoder.decodeObject(forKey: "id") as? String else {
                print("Error, id could not be loaded")
                return nil
            }
            let main = aDecoder.decodeBool(forKey: "main")
            
            self.init(name: name, id: id, main: main)
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(name, forKey: "name")
            aCoder.encode(id, forKey: "id")
            aCoder.encode(main, forKey: "main")
        }
    }
    
    public func AddFavourite(withID id : String, andName name : String) -> Bool {
        if(favourites[id] == nil) {
            favourites[id] = Favourite(name: name, id: id, main: false)
            SaveData()
            return true
        } else {
            return false
        }
    }
    
    public func RemoveFavourite(withID id : String) {
        favourites[id] = nil
        SaveData()
    }
    
    private func SaveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favourites, toFile: FavouritesController.ArchiveURL.path)
        print("Saving was a \(isSuccessfulSave ? "Success" : "Failure")")
    }
    
    private func LoadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: FavouritesController.ArchiveURL.path) as? [String: Favourite] {
            favourites = data
        }
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("favourites")
}
