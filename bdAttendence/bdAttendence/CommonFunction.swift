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
    if let bundle = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundle)
    }
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

func isShiftStart(time:String)->Bool{
    
    return false
    
}
func isShiftEnd(time:String)->Bool{
    return false
    
}


