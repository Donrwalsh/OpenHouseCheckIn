//
//  ViewController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ss_images2 = [SS_Image]()
    @IBOutlet weak var SSTableView2: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SSTableView2.delegate = self
        SSTableView2.dataSource = self
        
        if let savedSS_Images = loadSS_Images() {
            ss_images2 += savedSS_Images
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ss_images2.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SS_ImagesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SS_ImageTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let ss_image = ss_images2[indexPath.row]
        
        cell.nameLabel.text = ss_image.name
        cell.imagePreview.image = ss_image.photo
        cell.orderLabel.text = ""
        
        return cell
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
        
        print("potato")
        print(selectedImage)
        print("potato")
        
        
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
            
        case "AddItem":
            os_log("Adding a new SS_Image.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let SS_ImageViewController = segue.destination as? ss_ImageAddController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? SS_ImageTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = SSTableView2.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSS_Image = ss_images2[indexPath.row]
            SS_ImageViewController.ss_image = selectedSS_Image
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    
     //MARK: Actions
    
    @IBAction func unwindToConfigPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ss_ImageAddController, let ss_image = sourceViewController.ss_image {
            
            if let selectedIndexPath = SSTableView2.indexPathForSelectedRow {
                // Update an existing meal.
                ss_images2[selectedIndexPath.row] = ss_image
                SSTableView2.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: ss_images2.count, section: 0)
                
                ss_images2.append(ss_image)
                SSTableView2.insertRows(at: [newIndexPath], with: .automatic)
                SSTableView2.reloadRows(at: [newIndexPath], with: .none)
            }
            
            // Save the slideshow Images.
            saveSS_Images()
        }
    }
    
    
    //MARK: Private Methods
    
    private func saveSS_Images() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ss_images2, toFile: SS_Image.ArchiveURL.path)
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
