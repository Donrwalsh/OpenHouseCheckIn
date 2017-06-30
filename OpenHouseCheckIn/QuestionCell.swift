//
//  QuestionCell.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/29/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//


import UIKit

class QuestionCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    var question = [Question]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
