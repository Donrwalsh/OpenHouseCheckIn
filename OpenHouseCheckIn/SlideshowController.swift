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
    
    var ss_images = [SS_Image]()
    var imageSource = [ImageSource]()
    
    @IBOutlet weak var clickImage: UIImageView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSS_Images = loadSS_Images() {
            ss_images += savedSS_Images
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.hidden
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleToFill
        slideshow.draggingEnabled = false
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        for ssimage in ss_images {
            imageSource.append(ImageSource(image: ssimage.photo))
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
    
    private func loadSS_Images() -> [SS_Image]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SS_Image.ArchiveURL.path) as? [SS_Image]
    }
}

