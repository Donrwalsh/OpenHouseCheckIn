//
//  FormViewController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 5/27/17.
//  Copyright © 2017 Bigbrass. All rights reserved.
//

import Foundation
import Eureka

class MyFormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Contact Information")
            <<< TextRow(){ row in
                row.title = "Primary Contact Name"
                row.placeholder = "Enter primary contact name"
            }
            <<< TextRow("secondaryName"){ row in
                row.title = "Secondary Contact Name"
                row.placeholder = "Enter secondary contact name"
            }
            <<< PhoneRow(){
                $0.title = "Phone Number"
                $0.placeholder = "Enter phone number"
            }
            <<< EmailRow(){
                $0.title = "Email Address"
                $0.placeholder = "Enter email address"
            }
            +++ Section("How can I be of service?")
            <<< ActionSheetRow<String>() {
                $0.title = "Where are you in your house search?"
                $0.selectorTitle = "Pick an option"
                $0.options = ["Decline to answer","First-time Buyer","This isn't my first rodeo", "Looking to sell"]
                $0.value = "Decline to answer"    // initially selected
        }
            <<< SliderRow() {
                $0.title = "Your Budget is"
                $0.minimumValue = 0
                $0.maximumValue = 1000000
                $0.steps = 1000000
                $0.value = 0    // initially selected
        }
    }
}
