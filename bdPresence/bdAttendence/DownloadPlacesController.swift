//
//  DownloadPlacesController.swift
//  bdPresence
//
//  Created by Jeevan Tiwari on 14/08/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk




class DownloadPlaceController: UIViewController{
    
    var value = 0
    var timer = Timer()
    var progressValue = 0
    
    @IBOutlet weak var progressBar: LinearProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(DownloadPlaceController.getCallBack), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DownloadPlaceController.getCallBack), name: NSNotification.Name(rawValue: LocalNotifcation.GetUserHistoryAtLogin.rawValue), object: nil)
        
        
        progressBar.progressValue = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleUpdate), userInfo: nil, repeats: true)
        
        if LocationHistoryData.getLocationDataCount() == 0{
            
            LocationHistoryData.getTeamMember()
            
        }else{
            progressValue = progressValue + 1
            
            if progressValue == 2{
                goToHome()
            }
            //self.goToHome(userInfo: <#Notification#>)
        }
        
        
        RMCPlacesManager.getPlaces()
        
    }
    
    
    @objc func handleUpdate(){
        
        UI{
        self.value = self.value + 5
        print(self.value)
        
        if self.value == 100{
            self.timer.invalidate()
        }
        
        self.progressBar.progressValue = CGFloat(self.value)
        
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    
    func getCallBack(notification: Notification){
        progressValue  = progressValue + 1
        
        if let userInfo = notification.userInfo as? [String: Any]{
            
            if let from = userInfo["from"] as? String{
                
                
                
                if from == "history" {
                    if let value = userInfo["status"] as? Bool{
                        
                            UserDefaults.standard.setValue(value, forKey: "historyDataFetched")
                       
                        
                    }
                }else{
                    if let value = userInfo["status"] as? Bool{
                        
                        if value == true{
                            
                       // UserDefaults.standard.setValue(LogicHelper.shared.timeInSeconds, forKey: "RMCPlacesDuration")
                        UserDefaults.standard.set( Date(), forKey: "RMCPlacesDuration")
                           
                            
                        }
                        
                    }
                }
                
            }
        }
        
        if progressValue == 2{
            goToHome()
        }
        
        
    }
    
    
    func goToHome(){
        
        timer.invalidate()
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = destVC
        
    }
    

    
    
}
