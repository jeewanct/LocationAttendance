//
//  CommonFunction.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/04/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import RealmSwift
import BluedolphinCloudSdk
import GoogleMaps

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func ChangeRootVC(destinationView: UIViewController) {
    
    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = destinationView
    (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
}


func deleteAllData(){
    let realm = try! Realm()
    try! realm.write {
        realm.deleteAll()
    }
   
    guard let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String else {
     return
    }
    if let deviceIMEID = UserDefaults.standard.value(forKey: "RMCIMEI") as? String{
        SDKSingleton.sharedInstance.DeviceUDID = deviceIMEID
    }
    if let bundle = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundle)
    }
    UserDefaults.standard.setValue(deviceToken, forKey: UserDefaultsKeys.deviceToken.rawValue)
    UserDefaults.standard.setValue(SDKSingleton.sharedInstance.DeviceUDID, forKey: "RMCIMEI")
    UserDefaults.standard.synchronize()
    bdCloudStopMonitoring()
    
    
}

func moveToFirstScreen(){
     let storyboard = UIStoryboard(name: "NewDesign", bundle: nil)
    let destVc = storyboard.instantiateViewController(withIdentifier: "Root") as! UINavigationController
    ChangeRootVC(destinationView: destVc)
}

func sendToServer(){
    let checkinsCount = CheckinModel.getCheckinCount()
    if checkinsCount > 0{
        CheckinModel.postCheckin()
    }else{
        deleteAllData()
    }
}

func bdCloudStartMonitoring(){
    // putting a delay to start location monitoring
    // Sourabh - changed on 31/05/2018
    BlueDolphinManager.manager.stopLocationMonitoring()
    BlueDolphinManager.manager.startLocationMonitoring()

}

func bdCloudStopMonitoring(){
    BlueDolphinManager.manager.stopLocationMonitoring()
}

func isShiftStart(time:String)->Bool{
    
    return false
    
}
func isShiftEnd(time:String)->Bool{
    return false
    
}
func checkShiftStatus(completion : @escaping (APIResult) -> ()){
    
    UserDeviceModel.getDObjectsShift { (status) in
        switch (status){
        case APIResult.Success.rawValue:
            let shiftDetails = ShiftHandling.getShiftDetail()
            officeEndHour = shiftDetails.2
            officeStartHour = shiftDetails.0
            officeStartMin = shiftDetails.1
            officeEndMin = shiftDetails.3
            
            if let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.BDShiftId.rawValue) as? String{
                SDKSingleton.sharedInstance.shiftId = value
            }
            completion(.Success)
            break
            
        case APIResult.InvalidCredentials.rawValue:
            completion(.InvalidCredentials)
            break
            //self.showAlert(ErrorMessage.UserNotFound.rawValue)
            
        case APIResult.InternalServer.rawValue:
            completion(.InternalServer)
            break
            //self.showAlert(ErrorMessage.InternalServer.rawValue)
            
            
        case APIResult.InvalidData.rawValue:
            completion(.InvalidData)

            break
        //self.showAlert(ErrorMessage.NotValidData.rawValue)
        default:
            completion(.NoInternetConnection)

            break
            
        }
    }
    
    
}

