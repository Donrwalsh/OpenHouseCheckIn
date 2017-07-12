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
    
    var ssImages = [userImage]()
    var imageSource = [ImageSource]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var clickImage: UIImageView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    public var interval: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isKeyPresentInUserDefaults(key: "interval") {
            interval = defaults.object(forKey: "interval") as? Int ?? Int()
        } else {
            interval = 5
        }
        
        if let savedUserImages = loadUserImages() {
            for image in savedUserImages {
                if image.group == "SS" {
                    ssImages.append(image)
                }
            }
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
        

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        for ssImage in ssImages {
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
        print("potatodasdas")
        
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
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "configMainNav") 
                self.present(newViewController, animated: true, completion: nil)
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
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

