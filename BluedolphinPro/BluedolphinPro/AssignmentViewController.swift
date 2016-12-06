//
//  AssignmentViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 24/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift



class googleMapUsage {
    static let sharedInstance = googleMapUsage()
    var globalMapView = GMSMapView()
}

class AssignmentViewController: UIViewController ,GMSMapViewDelegate{
    var tableDataArray = ["hello","new","world","Go"];
    @IBOutlet weak var assignmentTableView: UITableView!
    
    
    @IBOutlet weak var mapView: UIView!
    var viewPager:ViewPagerControl!
    var tabView:ViewPagerControl!
    var menuView: CustomNavigationDropdownMenu!
    
    var tasks: Results<RMCAssignmentObject>!
    var subscription: NotificationToken?
    
    
    func getTasks(_ status: String) -> Results<RMCAssignmentObject> {
        let realm = try! Realm()
        tasks = realm.objects(RMCAssignmentObject.self)
//        switch status{
//            case "Downloaded":
//            tasks = tasks.filter("status = true")
//        default:break
//        }
    
        return tasks
//        return tasks.sorted([
//            SortDescriptor(property: "priority", ascending: false),
//            SortDescriptor(property: "created", ascending: false),
//            ])
    }
    
    func notificationSubscription(tasks: Results<RMCAssignmentObject>) -> NotificationToken {
        return tasks.addNotificationBlock {[weak self] (changes: RealmCollectionChange<Results<RMCAssignmentObject>>) in
            self?.updateUI(changes: changes)
        }
    }
    
    func updateUI(changes: RealmCollectionChange<Results<RMCAssignmentObject>>) {
        switch changes {
        case .initial(_):
            assignmentTableView.reloadData()
        case .update(_, let deletions, let insertions, _):
            
            assignmentTableView.beginUpdates()
            
            assignmentTableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)},
                                           with: .automatic)
            assignmentTableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)},
                                           with: .automatic)
            
            assignmentTableView.endUpdates()
            break
        case .error(let error):
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()
        
        // Do any additional setup after loading the view.
    }
    
    func createLayout(){
        tasks = getTasks("g")
        print(tasks.count)
        subscription = notificationSubscription(tasks:tasks)
        assignmentTableView.delegate = self
        assignmentTableView.dataSource = self
        let customView = UIView(frame: CGRect(x:0,y: 0, width:ScreenConstant.width,height: 50))
        customView.backgroundColor = UIColor.white
        assignmentTableView.tableFooterView = customView
        createNavView()
        createViewPager()
        createTabbarView()
        createMapView()
        
        
        let notificationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(notificationAction(_:)))
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(searchAction(_:)))
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        self.navigationItem.leftBarButtonItem = notificationButton

    }

    func notificationAction(_:Any){
        
    }
    func searchAction(_:Any){
        
    }
    
    
    func createMapView(){
        DispatchQueue.main.async {
            googleMapUsage.sharedInstance.globalMapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.mapView.frame.height))
            self.mapView.addSubview(googleMapUsage.sharedInstance.globalMapView)
            googleMapUsage.sharedInstance.globalMapView.delegate=self
            googleMapUsage.sharedInstance.globalMapView.animate(toZoom: 10)
            googleMapUsage.sharedInstance.globalMapView.clipsToBounds = true
            googleMapUsage.sharedInstance.globalMapView.isMyLocationEnabled = true
            googleMapUsage.sharedInstance.globalMapView.settings.myLocationButton = true
        }
    }
    
    
    func showCheckinMarkers(_ resultSet:Results
        <RMCAssignmentObject>){
        googleMapUsage.sharedInstance.globalMapView.clear()
        var bounds = GMSCoordinateBounds()
        DispatchQueue.main.async(execute: {
            for data in resultSet{
                
                
                let newlatlong = CLLocationCoordinate2D(latitude: Double(data.location!.latitude!)!, longitude: Double((data.location!.longitude!))!)
                print(newlatlong)
                
                if let appointmentTime = data.time {
                    
                    let scheduleTime = appointmentTime.asDate.formatted
                    let marker = PlaceMarker(coordinate: newlatlong)
                    marker.title = data.assignmentId
                    marker.snippet =  data.assignmentDetails! + "\n" + scheduleTime
                    bounds = bounds.includingCoordinate(marker.position)
                    marker.map = googleMapUsage.sharedInstance.globalMapView
                }
                
                
            }
            
            googleMapUsage.sharedInstance.globalMapView.animate(with: GMSCameraUpdate.fit(bounds))
        })
        //        dispatch_async(dispatch_get_main_queue(), {
        //
        //        })
        
    }
    func createViewPager(){
        let data = ["New","In Progress","Completed"]
        viewPager = ViewPagerControl(items: data)
        viewPager.type = .text
        viewPager.frame = CGRect(x: 0, y: 0
            , width: ScreenConstant.width, height: 40)
        viewPager.isHighlighted = true
        viewPager.selectionIndicatorColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        viewPager.selectionIndicatorHeight = 2
        viewPager.titleTextAttributes = [
            NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 13)!
        ]
        
        viewPager.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 13)!
        ]
        self.view.addSubview(viewPager)
        viewPager.setSelectedSegmentIndex(0, animated: false)
        viewPager.indexChangedHandler = { index in
            
            self.segmentControl(index: index)
            
        }
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    func swiped(sender:UISwipeGestureRecognizer){
        if let swipeGesture = sender as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                viewPager.setSelectedSegmentIndex(viewPager.selectedSegmentIndex + 1 > 2 ? 2:viewPager.selectedSegmentIndex + 1, animated: true)
            case UISwipeGestureRecognizerDirection.left:
                viewPager.setSelectedSegmentIndex(viewPager.selectedSegmentIndex - 1 < 0 ? 0:viewPager.selectedSegmentIndex - 1, animated: true)
                print("left swipe")
            default:
                print("other swipe")
            }
        }
    }
    
    func segmentControl(index:Int){
        print(index)
    }
    
    
    func createTabbarView(){
        let image1 = ["active list view","active map view","add new","Filter","sort"]
        let image2 = ["list","map view","add new","Filter","sort"]
        
        tabView = ViewPagerControl(images: image2, selectedImage: image1)
        //ViewPagerControl(items: data)
        tabView.type = .image
        tabView.frame = CGRect(x: 0, y: ScreenConstant.height - 124, width: ScreenConstant.width, height: 60)
        
        
        tabView.selectionIndicatorColor = UIColor.white
        //tabView.showSelectionIndication = false
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.tabChanger(segment: index)
            
        }
        
    }
        
    
    func createNavView(){
        let items = ["My Dashboard", "Assignments", "Calendar", "Call History", "Profile"]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        menuView = CustomNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Assignments", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        
        menuView.cellSelectionColor = UIColor.white
        //UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.black
        menuView.cellTextLabelFont = UIFont(name: "SourceSansPro-Regular", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.menuChanger(segment: indexPath)
            
        }
        
        self.navigationItem.titleView = menuView
    }
    
    func menuChanger(segment:Int){
        switch segment {
        case 1:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Assignment.rawValue) , object: nil)
            
        case 4:
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: LocalNotifcation.Profile.rawValue) , object: nil)
            
        default:
            break
        }
    }
    func tabChanger(segment:Int){
        switch segment {
        case 0:
            mapView.isHidden = true
        case 1:
            mapView.isHidden = false
            //showCheckinMarkers(tasks)
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getAssignmentData(){
//       var assignments = AssignmentModel().getAssignmentFromDb()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AssignmentViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell") as! AssignmentTableViewCell
        cell.configureWithTask(task)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
    
    
    
}
