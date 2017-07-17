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
    
    struct userData {
        static var ssImages = [userImage]()
        static var sdImages = [userImage]()
        static var questions = [Question]()
    }
    
    

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var slideshowInterval: UILabel!

    var toggle = false
    var newImageName: String!
    var currentImage: UIImage?
    var SSInterval: Int = 5
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var SSTableView: UITableView!
    @IBOutlet weak var editSSButton: UIButton!
    
    @IBOutlet weak var SDTableView: UITableView!
    @IBOutlet weak var editSDButton: UIButton!
    
    @IBOutlet weak var QuestionsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Checkpoint: ViewController super.viewDidLoad()")
        report_memory()
        
        for image in loadUserImages()! {
            if image.group == "SS" {
                userData.ssImages.append(image)
            } else if image.group == "SD" {
                userData.sdImages.append(image)
            }
        }
        loadSampleQuestions()
        for question in userData.questions {
            print(question.text)
        }
        
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
        QuestionsTableView.delegate = self
        QuestionsTableView.dataSource = self
        
        
        
        
        print("Checkpoint: ViewController end of override func viewDidLoad()")
        report_memory()
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
        } else if tableView == QuestionsTableView {
            return 1
        } else {
            fatalError("tableView Data Source Policy has been given an invalid table!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == SSTableView {
            return userData.ssImages.count
        } else if tableView == SDTableView {
            return userData.sdImages.count
        } else if tableView == QuestionsTableView {
            return userData.questions.count
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
            cell.nameLabel.text = userData.ssImages[indexPath.row].name
            cell.imagePreview.image = resizeImage(userData.ssImages[indexPath.row].photo, newHeight: 88)
            return cell
        } else if tableView == SDTableView {
            let cellIdentifier = "SD_ImagesTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SDImageTableViewCell  else {
                fatalError("The dequeued cell is not an instance of SDTable.")
            }
            let sdImage = userData.sdImages[indexPath.row]
            cell.nameLabel.text = sdImage.name
            cell.imagePreview.image = resizeImage(userData.sdImages[indexPath.row].photo, newHeight: 88)
            
            return cell
        } else if tableView == QuestionsTableView {
            let cellIdentifier = "QuestionsTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuestionCell else {
                fatalError("The dequeued cell is not an instance of QuestionsTable.")
            }
            cell.questionLabel.text = userData.questions[indexPath.row].type + " - " + userData.questions[indexPath.row].text
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
        } else if tableView == QuestionsTableView {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == SSTableView {
            if editingStyle == .delete {
                print("Deleted")
            
                userData.ssImages.remove(at: indexPath.row)
                SSTableView.deleteRows(at: [indexPath], with: .automatic)
                saveUserImages()
            }
        } else if tableView == SDTableView {
            if editingStyle == .delete {
                print("Deleted")
                
                userData.sdImages.remove(at: indexPath.row)
                SDTableView.deleteRows(at: [indexPath], with: .automatic)
                saveUserImages()
            }
        } else if tableView == QuestionsTableView {
            if editingStyle == .delete {
                print("Deleted")
                
                userData.questions.remove(at: indexPath.row)
                QuestionsTableView.deleteRows(at: [indexPath], with: .automatic)
                //Save Questions
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if tableView == SSTableView {
            if (!SSTableView.isEditing){
                return UITableViewCellEditingStyle.none
            } else {
                return UITableViewCellEditingStyle.delete
            }
        } else if tableView == SDTableView {
            if (!SDTableView.isEditing){
                return UITableViewCellEditingStyle.none
            } else {
                return UITableViewCellEditingStyle.delete
            }
        } else if tableView == QuestionsTableView {
            if (!QuestionsTableView.isEditing){
                return UITableViewCellEditingStyle.none
            } else {
                return UITableViewCellEditingStyle.delete
            }
        } else {
            return UITableViewCellEditingStyle.none;
        }
    }
    
    // Process the row move. This means updating the data model to correct the item indices.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if tableView == SSTableView {
            let item : userImage = userData.ssImages[sourceIndexPath.row]
            userData.ssImages.remove(at: sourceIndexPath.row)
            userData.ssImages.insert(item, at: destinationIndexPath.row)
            saveUserImages()
        } else if tableView == SDTableView {
            let item : userImage = userData.sdImages[sourceIndexPath.row]
            userData.sdImages.remove(at: sourceIndexPath.row)
            userData.sdImages.insert(item, at: destinationIndexPath.row)
            saveUserImages()
        } else if tableView == QuestionsTableView {
            let item : Question = userData.questions[sourceIndexPath.row]
            userData.questions.remove(at: sourceIndexPath.row)
            userData.questions.insert(item, at: destinationIndexPath.row)
            //Save Questions
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
            
            let selectedSSImage = userData.ssImages[indexPath.row]
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
            
            let selectedSDImage = userData.sdImages[indexPath.row]
            SD_ImageViewController.currentImage = selectedSDImage
            SD_ImageViewController.potato = "SDEdit"
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if toggle {
            let alert = UIAlertController(title: "Image Saved", message: newImageName + " has been saved.", preferredStyle: UIAlertControllerStyle.alert)
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
                    userData.ssImages[selectedIndexPath.row] = currentImage
                    SSTableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    // Add a new ss_image.
                    let newIndexPath = IndexPath(row: userData.ssImages.count, section: 0)
                    
                    userData.ssImages.append(currentImage)
                    SSTableView.insertRows(at: [newIndexPath], with: .automatic)
                    SSTableView.reloadRows(at: [newIndexPath], with: .none)
                }
                
                // Save the slideshow Images.
                
                saveUserImages()
                
                //Show successful save message.
                
                toggle = true
                newImageName = currentImage.name
            } else  if sourceViewController.potato == "SD" || sourceViewController.potato == "SDEdit" {
                if let selectedIndexPath = SDTableView.indexPathForSelectedRow {
                    // Update an existing sd_image.
                    userData.sdImages[selectedIndexPath.row] = currentImage
                    SDTableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    // Add a new sd_image.
                    let newIndexPath = IndexPath(row: userData.sdImages.count, section: 0)
                    
                    userData.sdImages.append(currentImage)
                    SDTableView.insertRows(at: [newIndexPath], with: .automatic)
                    SDTableView.reloadRows(at: [newIndexPath], with: .none)
                }
            
                // Save the slideshow Images.
                
                saveUserImages()
                
                //Show successful save message.
                
                toggle = true
                newImageName = currentImage.name
                
            }
            

        }

    }
    
    
    //MARK: Private Methods
    
    func resizeImage(_ image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(newImage!, 1)! as Data
        UIGraphicsEndImageContext()
        return UIImage(data:imageData)!
    }
    
    func report_memory() {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            if taskInfo.resident_size > 1024 && taskInfo.resident_size <= 1048576 {
                print("Memory used: \(taskInfo.resident_size/1024) KB")
            } else if taskInfo.resident_size > 1048576 && taskInfo.resident_size <= 1073741824 {
                print("Memory used: \(taskInfo.resident_size/1045876) MB")
            } else {
            print("Memory used in bytes: \(taskInfo.resident_size)")
            }
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    private func loadSampleQuestions() {
        
        guard let question1 = Question(text: "Name", type: "Text") else {
            fatalError("Unable to instantiate question1")
        }
        
        guard let question2 = Question(text: "Email Address", type: "Email") else {
            fatalError("Unable to instantiate question2")
        }
        
        guard let question3 = Question(text: "Phone Number", type: "Phone") else {
            fatalError("Unable to instantiate question3")
        }
        
        guard let question4 = Question(text: "This is a very long and complicated question, no way it would fit on one line.", type: "MC") else {
            fatalError("Unable to instantiate question4")
        }
        
        userData.questions += [question1, question2, question3, question4]
    }
    
    private func saveUserImages() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData.ssImages + userData.sdImages, toFile: userImage.ArchiveURL.path)
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
