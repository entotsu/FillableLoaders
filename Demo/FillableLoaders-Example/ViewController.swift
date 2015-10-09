//
//  ViewController.swift
//  FillableLoaders
//
//  Created by Pol Quintana on 2/8/15.
//  Copyright (c) 2015 Pol Quintana. All rights reserved.
//

import UIKit
import FillableLoaders

class ViewController: UIViewController {
    
    var segmentedControl: UISegmentedControl = UISegmentedControl()
    var button: UIButton = UIButton()
    var loader: WavesLoader = WavesLoader()
    var firstLogo: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupSubviews()

        // This will don't "addSubview".
        // This just make view.
        loader = WavesLoader.createLoaderView(
            path: Paths.heartPath(size: CGSize(width: 42, height: 40)),
            size: CGSize(width: 100, height: 100),
            color: UIColor.redColor()
        )
        loader.progress = 0.5
        view.addSubview(loader)
        loader.frame.origin = CGPoint(x: 100, y: 100)
        
        startAndStopTest()

        loader.layer.borderColor = UIColor.redColor().colorWithAlphaComponent(0.2).CGColor
        loader.layer.borderWidth = 2
    }
    
    func startAndStopTest() {
        
        NSTimer.schedule(delay: 3.34) { _ in
            self.loader.startAnimation()
            
            NSTimer.schedule(delay: 3.34) { _ in
                self.loader.progress = 0.9
                
                NSTimer.schedule(delay: 3.34) { _ in
                    self.loader.progress = 0.2
                    
                    NSTimer.schedule(delay: 3.34) { _ in
                        self.loader.progress = 0.4
                        
                        NSTimer.schedule(delay: 3.34) { _ in
                            self.loader.stopAnimation()
                            
                            NSTimer.schedule(delay: 3) { _ in
                                self.startAndStopTest()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setupSubviews() {
        let imageView = UIImageView(image: UIImage(named: "bg.png"))
        imageView.frame = view.frame
        view.addSubview(imageView)
        
        let margin: CGFloat = 30
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height
        let window = UIApplication.sharedApplication().delegate?.window!
        let items = ["Waves", "Plain", "Spike", "Rounded"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.tintColor = UIColor(white: 0.2, alpha: 1)
        segmentedControl.frame = CGRectMake(margin, height - margin - 40, width - margin*2, 40)
        segmentedControl.addTarget(self, action: "segmentedControlTouch:", forControlEvents: .ValueChanged)
        window!.addSubview(segmentedControl)
        
        button.frame = CGRectMake(0, 0, 150, 35)
        button.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 2*margin - 35)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.cornerRadius = 5.0
        button.setTitle("Change Logo", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.addTarget(self, action: "changeLogo", forControlEvents: .TouchUpInside)
        window!.addSubview(button)
    }
    
    func segmentedControlTouch(sender: UISegmentedControl) {
        presentFillableLoaderAtIndex(sender.selectedSegmentIndex)
    }
    
    func changeLogo() {
        firstLogo = !firstLogo
        presentFillableLoaderAtIndex(segmentedControl.selectedSegmentIndex)
    }
    
    func presentFillableLoaderAtIndex(index: Int) {
        loader.removeLoader(animated: false)
        switch index {
        default:
            loader = WavesLoader.showLoaderWithPath(path())
        }
        let window = UIApplication.sharedApplication().delegate?.window!
        window!.bringSubviewToFront(segmentedControl)
        window!.bringSubviewToFront(button)
    }
    
    func path() -> CGPath{
        return firstLogo ? Paths.smallBoxPath() : Paths.githubPath()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


extension NSTimer {
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}
