//
//  downSwipe.swift
//  OpenHouseCheckIn
//
//  Created by Laura Farvour on 7/5/17.
//  Copyright © 2017 Don Walsh. All rights reserved.
//

import UIKit
import os.log
import ImageSlideshow

class downSwipe: UIViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    var ssImages = [userImage]()
    var imageSource = [ImageSource]()
    
    
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedUserImages = loadUserImages() {
            for image in savedUserImages {
                if image.group == "SD" {
                    ssImages.append(image)
                }
            }
        }
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = PageControlPosition.hidden
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleToFill
        slideshow.draggingEnabled = true
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
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
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                //let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainSlideshow") as! SlideshowController
                //self.present(newViewController, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
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
}
