//
//  SS_Image.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/28/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit

class SS_ImageTableViewCell: UITableViewCell {
    
    //MARK: Properties

    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
