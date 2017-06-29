//
//  SS_Image.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/28/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

//This does not require images yet

import UIKit
import os.log

class SS_Image: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage
    var order: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ss_images")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let order = "order"
    }
    
    //MARK: Initialization
    
    //Prepares instance of a class for use, sets an initial value for each property and other setup or initializations
    
    init?(name: String, photo: UIImage, order: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        //The photo must not be empty
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.order = order
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(order, forKey: PropertyKey.order)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Slideshow Image object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of SS_Image, just use conditional cast.
        //^ nope
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as! UIImage
        
        let order = aDecoder.decodeInteger(forKey: PropertyKey.order)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, order: order)
        
    }
}
