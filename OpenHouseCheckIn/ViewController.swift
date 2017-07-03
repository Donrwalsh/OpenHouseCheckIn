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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ss_images = [SS_Image]()
    var toggle = false
    var new_ss_image: SS_Image!
    
    @IBOutlet weak var SSTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SSTableView.delegate = self
        SSTableView.dataSource = self
        
        
        
        if let savedSS_Images = loadSS_Images() {
            ss_images += savedSS_Images
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
            return ss_images.count
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
            let ss_image = ss_images[indexPath.row]
            
            cell.nameLabel.text = ss_image.name
            cell.imagePreview.image = ss_image.photo
            cell.orderLabel.text = ""
            
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
            
                ss_images.remove(at: indexPath.row)
                SSTableView.deleteRows(at: [indexPath], with: .automatic)
                saveSS_Images()
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
            let item : SS_Image = ss_images[sourceIndexPath.row];
            ss_images.remove(at: sourceIndexPath.row);
            ss_images.insert(item, at: destinationIndexPath.row)
            saveSS_Images()
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
            
            let selectedSS_Image = ss_images[indexPath.row]
            SS_ImageViewController.ss_image = selectedSS_Image
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if toggle {
            let alert = UIAlertController(title: "Saved", message: new_ss_image.name + " has been saved.", preferredStyle: UIAlertControllerStyle.alert)
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
        if let sourceViewController = sender.source as? ss_ImageAddController, let ss_image = sourceViewController.ss_image {
            
            if let selectedIndexPath = SSTableView.indexPathForSelectedRow {
                // Update an existing ss_image.
                ss_images[selectedIndexPath.row] = ss_image
                SSTableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new ss_image.
                let newIndexPath = IndexPath(row: ss_images.count, section: 0)
                
                ss_images.append(ss_image)
                SSTableView.insertRows(at: [newIndexPath], with: .automatic)
                SSTableView.reloadRows(at: [newIndexPath], with: .none)
            }
            
            // Save the slideshow Images.
            
            saveSS_Images()
            
            //Show successful save message.
            
            toggle = true
            new_ss_image = ss_image

        }

    }
    
    
    //MARK: Private Methods
    
    
    
    private func saveSS_Images() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ss_images, toFile: SS_Image.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("SS_Images successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save SS_Images...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSS_Images() -> [SS_Image]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SS_Image.ArchiveURL.path) as? [SS_Image]
    }
}
