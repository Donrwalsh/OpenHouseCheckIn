//
//  ViewController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

//Slideshows

import UIKit
import os.log

//Save user images working with multiple arrays?



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ssImages = [userImage]()
    var toggle = false
    var newSSImage: userImage!
    
    @IBOutlet weak var SSTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SSTableView.delegate = self
        SSTableView.dataSource = self
        
        if let savedUserImages = loadUserImages() {
            for image in savedUserImages {
                if image.group == "SS" {
                    ssImages.append(image)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == SSTableView {
            return 1
        } else {
            fatalError("tableView Data Source Policy has been given an invalid table!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == SSTableView {
            return ssImages.count
        } else {
            fatalError("tableView Data Source Policy has been given an invalid table!")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == SSTableView {
            let cellIdentifier = "SS_ImagesTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SS_ImageTableViewCell  else {
                fatalError("The dequeued cell is not an instance of SSTable.")
            }
            let ssImage = ssImages[indexPath.row]
            cell.nameLabel.text = ssImage.name
            cell.imagePreview.image = ssImage.photo
            
            return cell
        } else {
            fatalError("tableView Data Source Policy has been given an invalid table!")
        }
    }
    
    // Determine whether a given row is eligible for reordering or not.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        if tableView == SSTableView {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == SSTableView {
            if editingStyle == .delete {
                print("Deleted")
            
                ssImages.remove(at: indexPath.row)
                SSTableView.deleteRows(at: [indexPath], with: .automatic)
                saveUserImages()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if tableView == SSTableView {
            if (!SSTableView.isEditing){
                return UITableViewCellEditingStyle.none;
            }
            else{
                return UITableViewCellEditingStyle.delete;
            }
        } else {
            return UITableViewCellEditingStyle.none;
        }
    }
    
    // Process the row move. This means updating the data model to correct the item indices.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if tableView == SSTableView {
            let item : userImage = ssImages[sourceIndexPath.row];
            ssImages.remove(at: sourceIndexPath.row);
            ssImages.insert(item, at: destinationIndexPath.row)
            saveUserImages()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ss_ImageAdd") as! ss_ImageAddController
        self.present(nextViewController, animated:true, completion:nil)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "Slideshow":
            os_log("Navigating to slideshow.", log: OSLog.default, type: .debug)
        
        case "AddItem":
            os_log("Adding a new SS_Image.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let SS_ImageViewController = segue.destination as? ss_ImageAddController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? SS_ImageTableViewCell else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            guard let indexPath = SSTableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSSImage = ssImages[indexPath.row]
            SS_ImageViewController.ssImage = selectedSSImage
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if toggle {
            let alert = UIAlertController(title: "Saved", message: newSSImage.name + " has been saved.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Crushed it", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            toggle = false
        }
    }

    
     //MARK: Actions
    
    @IBAction func startEditing(_ sender: UIButton) {
        if !SSTableView.isEditing {
            editButton.setTitle("Done", for: .normal)
        } else {
            editButton.setTitle("Edit", for: .normal)
        }
        SSTableView.isEditing = !SSTableView.isEditing
    }
    
    @IBAction func unwindToConfigPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ss_ImageAddController, let ssImage = sourceViewController.ssImage {
            
            if let selectedIndexPath = SSTableView.indexPathForSelectedRow {
                // Update an existing ss_image.
                ssImages[selectedIndexPath.row] = ssImage
                SSTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new ss_image.
                let newIndexPath = IndexPath(row: ssImages.count, section: 0)
                
                ssImages.append(ssImage)
                SSTableView.insertRows(at: [newIndexPath], with: .automatic)
                SSTableView.reloadRows(at: [newIndexPath], with: .none)
            }
            
            // Save the slideshow Images.
            
            saveUserImages()
            
            //Show successful save message.
            
            toggle = true
            newSSImage = ssImage

        }

    }
    
    
    //MARK: Private Methods
    
    

    
    private func saveUserImages() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ssImages, toFile: userImage.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("SS_Images successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save SS_Images...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadUserImages() -> [userImage]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: userImage.ArchiveURL.path) as? [userImage]
    }
}
