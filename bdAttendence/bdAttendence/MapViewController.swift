


//
//  MapViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 24/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import MapKit
import BluedolphinCloudSdk


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: UIImage!
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.navigationItem.title = "Home"
        self.updateTask()
        
//        let whiteTextAttribute : [String : AnyObject] = [NSFontAttributeName:SourceFont.regular!,NSForegroundColorAttributeName: UIColor.white]
//        let yellowTextAttribute : [String : AnyObject] = [NSFontAttributeName:SourceFont.regular!,NSForegroundColorAttributeName:APPColor.yellow]
//        let attString = NSMutableAttributedString()
//        attString.append(NSAttributedString(string: "Current Location ", attributes: whiteTextAttribute))
//        attString.append(NSAttributedString(string: CurrentLocation.address, attributes: yellowTextAttribute))
//        print("Current Location \(CurrentLocation.address)")
//        locationLabel.attributedText = attString
//        locationLabel.numberOfLines = 0
//        locationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
  
    
        
   
        

        // Do any additional setup after loading the view.
    }
    
    func updateTask(){
        if isInternetAvailable() {
            self.showLoader()
            BlueDolphinManager.manager.updateToken()
            BlueDolphinManager.manager.getNearByBeacons()
        }
        
        BlueDolphinManager.manager.startScanning()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(locationCheckin), name: NSNotification.Name(rawValue: iBeaconNotifications.Location.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateTime(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.TimeUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateLocation(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.LocationUpdate.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.checkPermissionStatus(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.Background.rawValue), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(bluetoothDisabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconDisabled.rawValue), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(bluetoothEnabled), name: NSNotification.Name(rawValue: iBeaconNotifications.iBeaconEnabled.rawValue), object: nil)
        nameLabel.textColor = UIColor(hex: "74a8da")
        nameLabel.font = SourceFont.black
        nameLabel.text = "Hi \(SDKSingleton.sharedInstance.userName.capitalized.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))"
        timeLabel.clipsToBounds = true
        timeLabel.layer.cornerRadius = 18.0
        timeLabel.layer.borderWidth = 1.0
        timeLabel.layer.borderColor = APPColor.yellow.cgColor
        
        timeLabel.backgroundColor = APPColor.green
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        
        locationTitleLabel.textColor = UIColor.white
        locationTitleLabel.text = "Current Location"
        locationTitleLabel.textAlignment = .left
        locationTitleLabel.font = SourceFont.regular
        locationLabel.textColor = APPColor.yellow
        locationLabel.textAlignment = .left
        locationLabel.font = SourceFont.regular
        locationLabel.numberOfLines = 0
        if isInternetAvailable(){
            locationLabel.text = "Please Wait fetching Location"
        }else{
            locationLabel.text = "No internet Connection"
        }
        locationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if let value = UserDefaults.standard.value(forKey: "TotalTime") as? NSNumber {
            print("TotalTime")
            let (hour,min,_) = secondsToHoursMinutesSeconds(seconds: Int(value))
            timeLabel.text = "\(timeText(hour)):\(timeText(min)) hrs"
            
        }
            
        

    }
    
    func bluetoothEnabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = true
    }
    func bluetoothDisabled(){
        ProjectSingleton.sharedInstance.bluetoothAvaliable = false
    }
    func checkPermissionStatus(sender:NSNotification){
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                   ProjectSingleton.sharedInstance.locationAvailable = false
                case .authorizedAlways, .authorizedWhenInUse:
                    ProjectSingleton.sharedInstance.locationAvailable = true
                }
            } else {
               ProjectSingleton.sharedInstance.locationAvailable = false
            }
        
        print("Location enabled \(ProjectSingleton.sharedInstance.locationAvailable)")
        print("Bluetooth enabled \(ProjectSingleton.sharedInstance.bluetoothAvaliable)")
        if (ProjectSingleton.sharedInstance.locationAvailable && ProjectSingleton.sharedInstance.bluetoothAvaliable) == false{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "permission") as! PermissionViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func updateLocation(sender:NSNotification){
        if CurrentLocation.address.isBlank{
            if isInternetAvailable(){
              locationLabel.text = "Please Wait fetching Location"
            }else{
                locationLabel.text = "No internet Connection"
            }
        }else{
           locationLabel.text = CurrentLocation.address
        }
        
    }
    
    func updateTime(sender:NSNotification){
        if let value = UserDefaults.standard.value(forKey: "TotalTime") as? NSNumber {
            print("TotalTime")
         let (hour,min,_) = secondsToHoursMinutesSeconds(seconds: Int(value))
          timeLabel.text = "\(timeText(hour)):\(timeText(min)) hrs"
        
        }
    
    }
    
    
    func locationCheckin(sender:NSNotification){
        if let lastLocationCheckin = UserDefaults.standard.value(forKeyPath: "lastLocationCheckin") as? Date {
            print( "Difference last \(lastLocationCheckin.minuteFrom(Date()))")
            if Date().minuteFrom(lastLocationCheckin) > 2{
                let checkin = CheckinHolder()
                
                checkin.checkinDetails = [AssignmentWork.AppVersion.rawValue:APPVERSION as AnyObject,AssignmentWork.UserAgent.rawValue:"ios" as AnyObject]
                checkin.checkinCategory = CheckinCategory.Transient.rawValue
                checkin.checkinType = CheckinType.Location.rawValue
                //
                let checkinModelObject = CheckinModel()
                checkinModelObject.createCheckin(checkinData: checkin)
                UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
                if isInternetAvailable(){
                    checkinModelObject.postCheckin()
                }
            }
        } else{
            UserDefaults.standard.set(Date(), forKey: "lastLocationCheckin")
        }
        
        
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    func showLoader(text:String = "Updating User data" ){
        AlertView.sharedInstance.setLabelText(text)
        AlertView.sharedInstance.showActivityIndicator(self.view)
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            BlueDolphinManager.manager.startScanning()
        })
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MapViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,
                                                                  1000.0,1000.0)
        for anno in mapView.annotations{
            mapView.removeAnnotation(anno)
        }
        let annotation = CustomPointAnnotation()
        annotation.coordinate = userLocation.coordinate
       annotation.imageName = #imageLiteral(resourceName: "map_pin")
        
        mapView.addAnnotation(annotation)
        mapView.setCenter(userLocation.coordinate, animated: true)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "Location"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = cpa.imageName
        
        return anView
    }
  
    
}
