//
//  MainViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 01/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        NotificationCenter.default .removeObserver(self, name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default .addObserver(self, selector: #selector(MainViewController.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: LocalNotifcation.Pushreceived.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.ShowController(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue), object: nil)
       // self.updateNewAssignmentData(id: "dc26ecb6-0e80-4d9f-afb9-26ed20ce35f4")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShowController (sender : NSNotification) {
        switch (sender.name.rawValue) {
        case LocalNotifcation.Profile.rawValue:
            
            //      for views in mainContainer.subviews {
            //        views.removeFromSuperview()
            //      }
            //println(self.childViewControllers.count)
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            
            lastController?.willMove(toParentViewController: nil)
            //lastController?.willMoveToParentViewController(toSuperview: nil)
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileScene") as! UINavigationController
            //println(self.childViewControllers)
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            
            self.mainContainerView.addSubview(destVc.view)
            destVc.didMove(toParentViewController: self)
            
            
        case LocalNotifcation.Assignment.rawValue:
            
           
            var lastController: AnyObject?
            
            if let controller =  self.childViewControllers.first as? UINavigationController {
                lastController = controller
            } else {
                lastController = self.childViewControllers.last as! UINavigationController
            }
            for views in self.mainContainerView.subviews {
                views.removeFromSuperview()
            }
            lastController?.willMove(toParentViewController: nil)
           
            lastController?.removeFromParentViewController()
            let destVc = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentScene") as! UINavigationController
            self.addChildViewController(destVc)
            destVc.view.frame = self.mainContainerView.frame
            self.mainContainerView.addSubview(destVc.view)
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
    
    func methodOfReceivedNotification(notification: NSNotification){
        let result: NSDictionary = notification.userInfo! as NSDictionary
        let type:NotificationType = NotificationType(rawValue: result ["notificationType"] as! String)!
        switch type {
        case .Welcome:
            break
        case .NewAssignment:
            if let assignmentId = result["assignmentId"] as? String{
                updateNewAssignmentData(id: assignmentId)
            }
            
        }
        
       
        
        
        
        // //println(notification)
        
        //    self.goToScreen(status,info: result)
    }
    
    func goToScreen(flag:Int,info:NSDictionary){
        //switch flag {}
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushAlertView(userInfo:NSDictionary) {
        var alertMessage = ""
        //let result: AnyObject? = userInfo ["aps"]
        alertMessage = userInfo.value(forKey: "message")! as! String
        
        let alert2 = UIAlertController(title: "Message", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
            //pushReceived = false
            
            
            
        })
        alert2.addAction(cancelAction)
        alert2.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            
        }))
        
        
        self.present(alert2, animated: true, completion: nil)
        
    }
    
    
    
    
    func updateNewAssignmentData(id:String){
        let model = AssignmentModel()
        model.getAssignments(assignmentId: id) { (success) in
            
        }
        
        
        
    }

}
