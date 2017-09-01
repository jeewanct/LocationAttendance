//
//  MyDashboardViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 13/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk

//protocol myDashboardDelegate :class{
//    
//    func updateView(moveToView:Screen)
//    
//}

class MyDashboardViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    var errorView :ErrorScanView!
    var timerView:TimerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyDashboardViewController.updateView(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.CheckoutScreen.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyDashboardViewController.updateView(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.DayCheckinScreen.rawValue), object: nil)
//        let controller2 = self.storyboard?.instantiateViewController(withIdentifier: "checkout") as! NewCheckoutViewController
//        controller2.delegate = self
        
        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            var destVc:UINavigationController!
            switch screenFlag {
            case "1":
                destVc = self.storyboard?.instantiateViewController(withIdentifier: "newCheckout") as! UINavigationController
            case "2":
                destVc = self.storyboard?.instantiateViewController(withIdentifier: "newCheckin") as! UINavigationController
            default:
                break
            }
            
            updateChildController(destVc: destVc)
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let controller1 = self.storyboard?.instantiateViewController(withIdentifier: "checkin") as! NewCheckinViewController
//        controller1.delegate = self
    }
    
    func updateChildController(destVc:UINavigationController){
        var lastController: AnyObject?
        
        if let controller =  self.childViewControllers.first as? UINavigationController {
            lastController = controller
        } else {
            lastController = self.childViewControllers.last as! UINavigationController
        }
        for views in self.containerView.subviews {
            views.removeFromSuperview()
        }
        lastController?.willMove(toParentViewController: nil)
        
        lastController?.removeFromParentViewController()
        
        self.addChildViewController(destVc)
        print(self.containerView.frame)
        
        destVc.view.frame = self.containerView.frame
        self.containerView.addSubview(destVc.view)
        destVc.didMove(toParentViewController: self)
        //constraintViewEqual(view1: containerView, view2: (destVc.topViewController?.view)!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func updateView(moveToView: Screen) {
//        switch moveToView {
//        case .Checkin:
//            break
//        case .Checkout:
//            let destVc  = self.storyboard?.instantiateViewController(withIdentifier: "newCheckout") as! UINavigationController
//            
//    
//            UIView.transition(with: destVc.view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//                
//            }, completion: { (value) in
//                self.updateChildController(destVc: destVc)
//                
//            })
//            
//            break
//        case .Daycheckin:
//            break
//        default:
//            break
//        }
//    }
    
    func updateView(sender:NSNotification){
          switch (sender.name.rawValue) {
          case LocalNotifcation.CheckoutScreen.rawValue:
            BlueDolphinManager.manager.stopScanning()
            BlueDolphinManager.manager.startScanning()
            postDataCheckin(userInteraction: .swipeUp)
            checkSwipeUp()
            let destVc  = self.storyboard?.instantiateViewController(withIdentifier: "newCheckout") as! UINavigationController
            self.updateChildController(destVc: destVc)
            destVc.view.transform = CGAffineTransform(translationX:0 , y: containerView.frame.size.height)
            UIView.animate(withDuration: 0.3) {
              destVc.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            constraintViewEqual(view1: containerView, view2: destVc.view)
            
            
          case LocalNotifcation.DayCheckinScreen.rawValue:
           BlueDolphinManager.manager.stopScanning()
            postDataCheckin(userInteraction: .swipeDown)

            let destVc  = self.storyboard?.instantiateViewController(withIdentifier: "dayCheckin") as! UINavigationController
            self.updateChildController(destVc: destVc)
            destVc.view.transform = CGAffineTransform(translationX:0 , y: -containerView.frame.size.height)
            UIView.animate(withDuration: 0.3) {
                destVc.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            constraintViewEqual(view1: containerView, view2: destVc.view)
            
          default:
            break
        }
    }
    
    func postDataCheckin(userInteraction:CheckinDetailKeys){
        let checkin = CheckinHolder()
        
        checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject,CheckinDetailKeys.userInteraction.rawValue:userInteraction.rawValue as AnyObject]
        checkin.checkinCategory = CheckinCategory.Data.rawValue
        checkin.checkinType = CheckinType.Data.rawValue
        //
        
        CheckinModel.createCheckin(checkinData: checkin)
        
        if isInternetAvailable(){
            CheckinModel.postCheckin()
        }
    }
    
    
    private func constraintViewEqual(view1: UIView, view2: UIView) {
        view2.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: view1, attribute: .trailing, relatedBy: .equal, toItem: view2, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let constraint3 = NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let constraint4 = NSLayoutConstraint(item: view1, attribute: .leading, relatedBy: .equal, toItem: view2, attribute: .leading, multiplier: 1.0, constant: 0.0)
        view1.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }
    
    func checkSwipeUp(){
        delayWithSeconds(10) {
            if BlueDolphinManager.manager.seanbeacons.count == 0 {
                self.showErrorCustomView()
            }else{
                
            }
        }
        
    }
    func showErrorCustomView(){
       
         errorView = ErrorScanView(frame: self.view.frame)
            //ErrorScanView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height))
       UIView.transition(with: errorView, duration: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
    
       }) { (value) in
        self.view.addSubview(self.errorView)
        self.errorView.delegate = self
        self.errorView.createView()
        }
    }
    func removeErrorCustomView(){
        
        UIView.transition(with: errorView, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
        }) { (value) in
            self.errorView.removeFromSuperview()
            self.errorView.delegate = nil
        }
    }
    
    
    func showLoader(text:String = "Scanning ..." ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 10.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            //self.dismiss(animated: true, completion: nil)
        })
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MyDashboardViewController:CheckinViewDelegate {
    func updateView(moveToView: Screen) {
        switch moveToView {
        case .Timer:
            self.showLoader()
            delayWithSeconds(10
                , completion: {
                if BlueDolphinManager.manager.seanbeacons.count != 0 {
                    self.removeErrorCustomView()
                }
            })
        case .Checkin:
            removeErrorCustomView()
            
        case .Checkout,.Daycheckin,.PayPal:
            break
            
        }
    }
    
    
}
