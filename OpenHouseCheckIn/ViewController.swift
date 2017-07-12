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
    

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var slideshowInterval: UILabel!
    var ssImages = [userImage]()
    var sdImages = [userImage]()
    var toggle = false
    var newImage: userImage!
    var SSInterval: Int = 5
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var SSTableView: UITableView!
    @IBOutlet weak var editSSButton: UIButton!
    
    @IBOutlet weak var SDTableView: UITableView!
    @IBOutlet weak var editSDButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "interval") {
            SSInterval = defaults.object(forKey: "interval") as? Int ?? Int()
            slideshowInterval.text = String(SSInterval)
            stepper.value = Double(SSInterval)
        }
        
        
        //slideshowInterval.text = String(describing: defaults.object(forKey: "interval") as? [Int: Int] ?? [Int: Int]()) ?? 5
        
        SSTableView.delegate = self
        SSTableView.dataSource = self
        SDTableView.delegate = self
        SDTableView.dataSource = self
        
        
        
        if let savedUserImages = loadUserImages() {
            for image in savedUserImages {
                if image.group == "SS" {
                    ssImages.append(image)
                } else if image.group == "SD" {
                    sdImages.append(image)
                }
            }
        }
        print(sdImages.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == SSTableView {
            return 1
        } else if tableView == SDTableView {
            return 1
        } else {
            fatalError("tableView Data Source Policy has been given an invalid table!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == SSTableView {
            return ssImages.count
        } else if tableView == SDTableView {
            return sdImages.count
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
        } else if tableView == SDTableView {
            let cellIdentifier = "SD_ImagesTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SDImageTableViewCell  else {
                fatalError("The dequeued cell is not an instance of SDTable.")
            }
            let sdImage = sdImages[indexPath.row]
            cell.nameLabel.text = sdImage.name
            cell.imagePreview.image = sdImage.photo
            
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
        } else if tableView == SDTableView {
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
        } else if tableView == SDTableView {
            if editingStyle == .delete {
                print("Deleted")
                
                sdImages.remove(at: indexPath.row)
                SDTableView.deleteRows(at: [indexPath], with: .automatic)
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
        } else if tableView == SDTableView {
            if (!SDTableView.isEditing){
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
        } else if tableView == SDTableView {
            let item : userImage = sdImages[sourceIndexPath.row];
            sdImages.remove(at: sourceIndexPath.row);
            sdImages.insert(item, at: destinationIndexPath.row)
            saveUserImages()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "Slideshow":
            os_log("Navigating to slideshow.", log: OSLog.default, type: .debug)
        
        case "AddSS":
            os_log("Adding a new SSImage.", log: OSLog.default, type: .debug)
            let ssImageAddController = segue.destination.childViewControllers[0] as! ss_ImageAddController
            ssImageAddController.potato = "SS"
            
        case "AddSD":
            os_log("Adding a new SDImage.", log: OSLog.default, type: .debug)
            let ssImageAddController = segue.destination.childViewControllers[0] as! ss_ImageAddController
            ssImageAddController.potato = "SD"
            
        case "ShowDetailSS":
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
            SS_ImageViewController.currentImage = selectedSSImage
            SS_ImageViewController.potato = "SSEdit"
            
        case "ShowDetailSD":
            guard let SD_ImageViewController = segue.destination as? ss_ImageAddController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? SDImageTableViewCell else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            guard let indexPath = SDTableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSDImage = sdImages[indexPath.row]
            SD_ImageViewController.currentImage = selectedSDImage
            SD_ImageViewController.potato = "SDEdit"
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if toggle {
            let alert = UIAlertController(title: "Image Saved", message: newImage.name + " has been saved.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Crushed it", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            toggle = false
        }
    }

    
    //MARK: Actions
    

    //Edit the Slideshow Images Table
    @IBAction func startEditing(_ sender: UIButton) {
        if !SSTableView.isEditing {
            editSSButton.setTitle("Done", for: .normal)
        } else {
            editSSButton.setTitle("Edit", for: .normal)
        }
        SSTableView.isEditing = !SSTableView.isEditing
    }
    
    @IBAction func startEditingSDImages(_ sender: UIButton) {
        if !SDTableView.isEditing {
            editSDButton.setTitle("Done", for: .normal)
        } else {
            editSDButton.setTitle("Edit", for: .normal)
        }
        SDTableView.isEditing = !SDTableView.isEditing
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        slideshowInterval.text = String(Int(sender.value))
        defaults.set(Int(slideshowInterval.text!), forKey: "interval")
    }
    
    
    
    
    @IBAction func unwindToConfigPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ss_ImageAddController, let currentImage = sourceViewController.currentImage {
            if sourceViewController.potato == "SS" || sourceViewController.potato == "SSEdit" {
                if let selectedIndexPath = SSTableView.indexPathForSelectedRow {
                    // Update an existing ss_image.
                    ssImages[selectedIndexPath.row] = currentImage
                    SSTableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    // Add a new ss_image.
                    let newIndexPath = IndexPath(row: ssImages.count, section: 0)
                    
                    ssImages.append(currentImage)
                    SSTableView.insertRows(at: [newIndexPath], with: .automatic)
                    SSTableView.reloadRows(at: [newIndexPath], with: .none)
                }
                
                // Save the slideshow Images.
                
                saveUserImages()
                
                //Show successful save message.
                
                toggle = true
                newImage = currentImage
            } else  if sourceViewController.potato == "SD" || sourceViewController.potato == "SDEdit" {
                if let selectedIndexPath = SDTableView.indexPathForSelectedRow {
                    // Update an existing sd_image.
                    sdImages[selectedIndexPath.row] = currentImage
                    SDTableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    // Add a new sd_image.
                    let newIndexPath = IndexPath(row: sdImages.count, section: 0)
                    
                    sdImages.append(currentImage)
                    SDTableView.insertRows(at: [newIndexPath], with: .automatic)
                    SDTableView.reloadRows(at: [newIndexPath], with: .none)
                }
            
                // Save the slideshow Images.
                
                saveUserImages()
                
                //Show successful save message.
                
                toggle = true
                newImage = currentImage
            }

            

        }

    }
    
    
    //MARK: Private Methods
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    
    private func saveUserImages() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ssImages + sdImages, toFile: userImage.ArchiveURL.path)
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
