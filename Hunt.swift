//
//  Hunt.swift
//  Escave
//
//  Created by Ryan Schoenlein on 5/20/19.
//  Copyright © 2019 Ryan Schoenlein. All rights reserved.
//

import UIKit
import os.log
import MapKit

//Hunt inherits superclasses NSObject and NSCoding that allows for data to persist in multiple app sessions
class Hunt: NSObject, NSCoding {
  
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var lat: Double
    var long: Double
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hunts")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let lat = "lat"
        static let long = "long"
    }
    
    //MARK: Initialization
    //(constructor)
    init?(name: String, photo: UIImage?, rating: Int, lat: Double, long: Double) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.lat = lat
        self.long = long
        
    }
    
    //MARK: NSCoding, inherited methods that must be defined
    
    //encode class data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(lat, forKey: PropertyKey.lat)
        aCoder.encode(long, forKey: PropertyKey.long)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    
    //decodes archived data for the rating, photo and name of the item
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Hunt object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Hunt, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        let lat = aDecoder.decodeDouble(forKey: PropertyKey.lat)

        let long = aDecoder.decodeDouble(forKey: PropertyKey.long)

        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, lat: lat, long: long)
    }
}
