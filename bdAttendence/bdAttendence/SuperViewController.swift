//
//  SuperViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 22/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
    var window: UIWindow?
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sideMenuContainer: UIView!
    
    @IBOutlet weak var menuLeadingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var mainContainer: UIView!
    
    var visualEffectView = UIVisualEffectView()
    var bool = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurView.alpha = 0
        //println(self.childViewControllers)
        menuLeadingSpace.constant = -sideMenuContainer.bounds.size.width
        
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = false
        
        let leftSwipeOnTransparentView =  UISwipeGestureRecognizer(target: self, action: #selector(SuperViewController.handleSwipes(sender:)))
        let leftSwipeOnContainerView = UISwipeGestureRecognizer(target: self, action: #selector(SuperViewController.handleSwipes(sender:)))
        leftSwipeOnTransparentView.direction = .left
        leftSwipeOnContainerView.direction = .left
        
        sideMenuContainer.addGestureRecognizer(leftSwipeOnContainerView)
        blurView.addGestureRecognizer(leftSwipeOnTransparentView)
        blurView.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        
        if self.window != nil {
            self.window!.rootViewController = self
        }
        
    }
    func handleLeftGesture() {
        self.showMenuView()
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        setObservers()
        
    }
    
    func setObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowSideMenu(sender:)), name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SuperViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.VirtualBeacon.rawValue), object: nil)
        
    }
    
    @IBAction func invisibleButtonAction(_ sender: Any) {
        self.slideMenuViewToLeft()
    }
 
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            //////////println("Swipe Left")
            self.slideMenuViewToLeft()
        }
        if (sender.direction == .right) {
            //////////println("Swipe Right")
        }
    }
    
    func slideMenuViewToLeft() {
        
        self.menuLeadingSpace.constant = -sideMenuContainer.bounds.size.width
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (Bool) -> Void in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenuView () {
        
        menuLeadingSpace.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            self.blurView.alpha = 1
        }, completion: { (Bool) -> Void in
            
        })
    }
    func ShowSideMenu(sender : NSNotification) {
        self.showMenuView()
        
    }
    
    
    
    
}



extension SuperViewController {
    func ShowController (sender : NSNotification) {
        switch (sender.name.rawValue) {
            
        case LocalNotifcation.Assignment.rawValue:
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainer.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
            
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentScene") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainer.frame
            self.mainContainer.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
        default:
            /* let destVc = self.storyboard?.instantiateViewControllerWithIdentifier("blue") as! UINavigationController
             self.addChildViewController(destVc)
             destVc.view.frame = self.mainContainer.frame
             self.mainContainer.addSubview(destVc.view)
             destVc.didMoveToParentViewController(self)*/
            print("")
        }
    }
    
    
}





