//
//  ss_ImageAddController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log

class ss_ImageAddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectImageText: UILabel!
    
    var currentImage: userImage?
    var toggle = false
    public var potato: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        previewImage.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        previewImage.layer.cornerRadius = 5.0
        previewImage.layer.borderWidth = 2
        
        if let currentImage = currentImage {
            nameTextField.text = currentImage.name
            previewImage.image = currentImage.photo
            toggle = true
            selectImageText.text = ""
        }
        updatePageTitle()
        
        // Enable the Save button only if the text field and picture are populated.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        updatePageTitle()
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        previewImage.image = selectedImage
        toggle = true
        selectImageText.text = " "
        updateSaveButtonState()
        updatePageTitle()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSS_ImageMode = presentingViewController is UINavigationController
        
        if isPresentingInAddSS_ImageMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The View Controller is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = previewImage.image
        var group = " "
        if (potato == "SS" || potato == "SSEdit") {
            group = "SS"
        } else if potato == "SD" {
            group = "SD"
        }
        
        
        currentImage = userImage(name: name, photo: photo!, group: group)
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        // .overCurrentContext allows for landscape and portrait mode
        imagePickerController.modalPresentationStyle = .overCurrentContext
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        if (!text.isEmpty && toggle) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func updatePageTitle() {
        if potato == "SS" {
            self.navigationItem.title = "New Slideshow Image"
            if nameTextField.text != nil {
                self.navigationItem.title = "New Slideshow Image: " + nameTextField.text!
            }
        } else if potato == "SSEdit" {
            self.navigationItem.title = "Editing Slideshow Image: " + nameTextField.text!
        } else if potato == "SD" {
            self.navigationItem.title = "New Swipe Down Image"
        } else if potato == "SDEdit" {
            self.navigationItem.title = "Editing Swipe Down Image: " + nameTextField.text!
        }
    }
    
    

    
}

