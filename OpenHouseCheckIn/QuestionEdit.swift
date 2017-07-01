//
//  QuestionEdit.swift
//  OpenHouseCheckIn
//
//  Created by Laura Farvour on 6/30/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log
import DLRadioButton

class QuestionEdit: UIViewController, UITextFieldDelegate, UIApplicationDelegate {
    
    @IBOutlet weak var questionDesc: UILabel!
    
    @IBOutlet weak var emailButton: DLRadioButton!
    @IBOutlet weak var textButton: DLRadioButton!
    @IBOutlet weak var questionType: UILabel!
    
    @IBOutlet weak var questionPrompt: UILabel!

    @IBOutlet weak var questionField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateQuestionType()
        

        
        // Enable the Save button only if the text field and picture are populated.

    }
    
    
    //MARK: Private Methods
    
    private func updateQuestionType() {
        if (emailButton.isSelected) {
            questionType.text = "Step 2: Compose Email Question:"
            questionDesc.text = "Email: Free-form text field with email- specific keyboard."
            questionPrompt.isEnabled = true
            questionPrompt.isHidden = false
            questionField.isEnabled = true
            questionField.isHidden = false
        } else if (textButton.isSelected) {
            questionType.text = "Step 2: Compose Text Question:"
            questionDesc.text = "Text: Free-form text field with full keyboard. Good for name or open-answer questions."
            questionPrompt.isEnabled = true
            questionPrompt.isHidden = false
            questionField.isEnabled = true
            questionField.isHidden = false
        } else {
            questionType.text = " "
            questionPrompt.isEnabled = false
            questionPrompt.isHidden = true
            questionField.isEnabled = false
            questionField.isHidden = true
        }
    }
    
    
    @IBAction func textButton(_ sender: DLRadioButton) {
        updateQuestionType()
    }
    
    @IBAction func emailButton(_ sender: DLRadioButton) {
        updateQuestionType()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert", message: "Both buttons proceed with the exit", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}

