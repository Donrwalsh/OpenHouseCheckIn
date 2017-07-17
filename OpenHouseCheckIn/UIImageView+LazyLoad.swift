//
//  UIImageView+LazyLoad.swift
//  OpenHouseCheckIn
//
//  Created by Laura Farvour on 7/16/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async() {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
