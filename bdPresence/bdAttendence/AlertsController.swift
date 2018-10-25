//
//  AlertsController.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 08/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit


class AlertsController{
    
    static let shared = AlertsController()
    
    func displayAlertWithoutAction(whereToShow viewController: UIViewController, message: String){
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func displaySpreadsheet(whereToShow viewController: UIViewController, message: String){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
