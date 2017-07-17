//
//  SlideshowController.swift
//  OpenHouseCheckIn
//
//  Created by Don Walsh on 6/27/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log
import ImageSlideshow

class SlideshowController: UIViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    var imageSource = [ImageSource]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var clickImage: UIImageView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    public var interval: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Checkpoint: SlideShow Controller super.viewDidLoad()")
        report_memory()
        
        if isKeyPresentInUserDefaults(key: "interval") {
            interval = defaults.object(forKey: "interval") as? Int ?? Int()
        } else {
            interval = 5
        }
        
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = Double(interval!)
        slideshow.pageControlPosition = PageControlPosition.hidden
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleToFill
        slideshow.draggingEnabled = false
        slideshow.preload = ImagePreload.fixed(offset: 3)
        

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        for ssImage in ViewController.userData.ssImages {
            imageSource.append(ImageSource(image: ssImage.photo))
        }
        slideshow.setImageInputs(imageSource)
        
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        //slideshow.addGestureRecognizer(recognizer)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "downSwipe") as! downSwipe
                self.present(newViewController, animated: true, completion: nil)
            case UISwipeGestureRecognizerDirection.left:
                //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                //let newViewController = storyBoard.instantiateViewController(withIdentifier: "configMainNav")
                //self.present(newViewController, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
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
    
    func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        print("down")
    }
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        print("potato")
    }
    
    private func loadUserImages() -> [userImage]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: userImage.ArchiveURL.path) as? [userImage]
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

