//
//  QuestionTableCell.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 7/17/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//
import UIKit

class QuestionCell: UITableViewCell {
    
    //MARK: Properties

    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
