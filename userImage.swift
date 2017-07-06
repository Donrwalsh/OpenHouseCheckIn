//
//  userImage.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 7/6/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log

class userImage: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage
    var group: String
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userImages")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let group = "group"
    }
    
    //MARK: Initialization
    
    //Prepares instance of a class for use, sets an initial value for each property and other setup or initializations
    
    init?(name: String, photo: UIImage, group: String) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The type must not be empty
        guard !group.isEmpty else {
            return nil
        }
        //The photo must not be empty
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.group = group
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(group, forKey: PropertyKey.group)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a userImage object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let group = aDecoder.decodeObject(forKey: PropertyKey.group) as? String else {
            os_log("Unable to decode the group of a userImage object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // This needs to required the photo, like the above two do for the name and group.
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as! UIImage
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, group: group)
        
    }
}
