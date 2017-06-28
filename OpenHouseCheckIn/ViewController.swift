//
//  ViewController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ss_images = [String]()
    @IBOutlet weak var SSTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("ss_") { //All the slideshow images must be save with 'ss_'
                ss_images.append(item)
            }
        }
        print(ss_images)
        SSTableView.delegate = self
        SSTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ss_images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Calling cellForRowAt method which must return a table view cell. (Created in the interface builder)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ss_image", for: indexPath)
        //iOS treats cells in a table view as rotating. This^ line dequeues a recycled cell from the table.
        let replaced = ss_images[indexPath.row].replacingOccurrences(of: "ss_", with: "", options: .literal, range: nil)
        cell.textLabel?.text = replaced
        //The ? means do this only if there is an actual text label there, do nothing otherwise.
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ss_images[indexPath.row])
        
    }
}
