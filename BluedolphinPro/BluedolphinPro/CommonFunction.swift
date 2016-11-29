//
//  CommonFunction.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 29/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

//
//func changeNavigationStack(stack:Int){
//    
//    switch stack {
//    case 0:
//        var lastController: AnyObject?
//        
//        if let controller =  self.childViewControllers.first as? UINavigationController {
//            lastController = controller
//        } else {
//            lastController = self.childViewControllers.last as! UINavigationController
//        }
//        for views in self.mainContainer.subviews {
//            views.removeFromSuperview()
//        }
//        lastController?.willMoveToParentViewController(nil)
//        lastController?.removeFromParentViewController()
//        let destVc = self.storyboard?.instantiateViewControllerWithIdentifier("AssignmentScene") as! UINavigationController
//        //println(self.childViewControllers)
//        self.addChildViewController(destVc)
//        destVc.view.frame = self.mainContainer.frame
//        
//        self.mainContainer.addSubview(destVc.view)
//        destVc.didMoveToParentViewController(self)
//        break
//    case 1:
//        break
//    case 2:
//        break
//    case 3:
//        break
//    case 4:
//        break
//    default:
//        break
//    }
//    
//}
