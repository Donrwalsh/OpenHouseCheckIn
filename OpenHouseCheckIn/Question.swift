\







































































//
//  Created by Laura Farvour on 6/29/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log

class Question: NSObject, NSCoding {
    
    //MARK: Properties
    
    var text: String
    var type: String
    
    //MARK: Types
    
    struct PropertyKey {
        static let text = "text"
        static let type = "type"
    }
    
    init?(text: String, type: String) {
        // The text must not be empty
        guard !text.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.text = text
        self.type = type
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: PropertyKey.text)
        aCoder.encode(type, forKey: PropertyKey.type)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let text = aDecoder.decodeObject(forKey: PropertyKey.text) as? String else {
            os_log("Unable to decode the name for a Question object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String else {
            os_log("Unable to decode the name for a Question object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        
        // Must call designated initializer.
        self.init(text: text, type: type)
        
    }
}

