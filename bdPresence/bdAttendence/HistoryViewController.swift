//
//  HistoryViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 25/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import GoogleMaps
import BluedolphinCloudSdk

class HistoryViewController: UIViewController {

    @IBOutlet weak var swipeUpButton: UIButton!
    @IBOutlet weak var calenderView: UICollectionView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var barchartView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    var thisWeekDays = [Date]()
    var currentDisplayDate = Date()
    
    @IBOutlet weak var mapView: GMSMapView!
    
  
    /* Changes made from 10th July '18 */
    
    
    var pullController: SearchViewController!
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.removeTransparency()
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.title = Date().formattedWith(format: "MMMM yyyy")
        calenderView.delegate = self
        calenderView.dataSource = self
        self.startLabel.font = APPFONT.VERSIONTEXT
        self.endLabel.font = APPFONT.VERSIONTEXT
        getCalenderData()
        calenderView.register(UINib(nibName: "WeekCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weekCell")
    
        
         self.swipeUpButton.isHidden = true
        self.swipeUpButton.frame.size.width = 0
        
       currentDisplayDate = Date().dayStart()!
        
        
        /* Changes made from 10th July '18 */
        
        setupMap()
//        addGestureInContainerView()

        
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryViewController.discardFakeLocations), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
        }
        
        
        if let getTimer = self.timer{
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func discardFakeLocations(){
        updateView()
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    
    
    @IBAction func showTimeLineView(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "timeLine") as? UINavigationController
        let topcontroller = controller?.topViewController as! TimeLineViewController
        topcontroller.currentDate = self.currentDisplayDate
        self.present(controller!, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getCalenderData(){
        thisWeekDays =  formattedDaysInThisWeek()
        calenderView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if let index = thisWeekDays.index(of: currentDisplayDate) {
            
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView(calenderView, didSelectItemAt: indexPath)

            calenderView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.bottom)
            
        }
        
        
    }
    
   
    
    func formattedDaysInThisWeek()->[Date]  {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .flatMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            //.filter { !calendar.isDateInWeekend($0)
       return days
    }
    
    
    func updateView(date:Date = Date()){
        
        //progressBar.maxValue = CGFloat((officeEndHour - officeStartHour) * 3600)
        //progressBar.innerRingColor = APPColor.newGreen

        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkers(date: date)
        
        
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        var finalLocations = allLocations

       
        if allLocations.count == 0{
        }else{
            //plotPathInMap(location: allLocations)
            // first change the location in ascending order
//            finalLocations.sort(by: { (first, second) -> Bool in
//                
//                if let firstDate = first.lastSeen , let secondDate = second.lastSeen{
//                    return  firstDate.compare(secondDate) == .orderedAscending
//
//
//                }
//                
//                return false
//            })

            
            pullController = UIStoryboard(name: "NewDesign", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
            pullController.screenType = LocationDetailsScreenEnum.historyScreen
            self.addPullUpController(pullController, animated: true)
            
            
            pullController.locationData = allLocations
            pullController.tableView.reloadData()
            
            let polyLine = PolyLineMap()
            polyLine.delegate = self
            polyLine.getPolyline(location: allLocations)
            
            // getLocationCorrospondingLatLong(locations: allLocations)
        }
        
        
        
        for locations in allLocations{
            
            for geoTaggedLocation in locations{
                
                if let geoTagg = geoTaggedLocation.geoTaggedLocations{
                    
                    addMarker(latitude: geoTagg.latitude, longitude: geoTagg.longitude, markerColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
                }else{
                    
                    addMarker(latitude: geoTaggedLocation.latitude, longitude: geoTaggedLocation.longitude, markerColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                }
                
            }
            
            
        }
    }
    
    
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        
        
        for coordinate in coordinates{
            path.add(coordinate)
            
        }
        
        if coordinates.count > 1{
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds))
        }
        

        // mapView.animate(with: GMSCameraUpdate()
        // mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 40))
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 3
        polyline.map = mapView
        
//        if self.timer == nil && coordinates.count > 1 {
//            self.timer = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
//
//        }
        
    }
    
    
    func addMarker(latitude: String?, longitude: String?, markerColor: UIColor){
        let marker = GMSMarker()
        if let lat = latitude, let long = longitude{
            
            if let locationLat = CLLocationDegrees(lat), let locationLong = CLLocationDegrees(long){
                
                marker.position = CLLocationCoordinate2D(latitude:  locationLat, longitude: locationLong)
                
                
                marker.title = "Sydney"
                marker.snippet = "Australia"
                let iconImageView = UIImageView(image: #imageLiteral(resourceName: "locationBlack").withRenderingMode(.alwaysTemplate))
                iconImageView.tintColor = markerColor
                marker.iconView = iconImageView
                
                marker.map = mapView
                
                
                let camera = GMSCameraPosition.camera(withLatitude: locationLat, longitude: locationLong, zoom: 17.0)
                mapView.camera = camera
                
                
                //path.add(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))
                
            }
            
            
            
        }
        
        
    }
    
    
    
    
    
    func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.gray
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    
    
    
    func getDateInAMPM(date:Date)->String{
        print(date)
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .none
        
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from:date)
        
    }
    

}

extension HistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.invalidateLayout()
       
        
        return CGSize(width: collectionView.frame.width/7, height:collectionView.frame.height) // Set your item size here
    }
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView.frame)
        return thisWeekDays.count
    }

   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentData = thisWeekDays[indexPath.row]
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath as IndexPath)  as! DayCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekCollectionViewCell
        cell.cellLabel.text = currentData.formattedWith(format: "EEEEE")
        cell.cellLabel.font = APPFONT.DAYCHAR
            
        cell.dateLabel.text = currentData.formattedWith(format: "d")
//        cell.dateView.layer.cornerRadius = cell.dateLabel.frame.width / 2
//        cell.dateView.clipsToBounds = true
        if (currentData.timeIntervalSinceNow.sign == .plus) {
            // date is in future
            cell.cellLabel.textColor = UIColor.gray
            cell.dateLabel.textColor = UIColor.gray
            cell.isUserInteractionEnabled = false
        }else{
            cell.dateLabel.textColor = UIColor.black
            cell.cellLabel.textColor = UIColor.black
            cell.isUserInteractionEnabled = true
        }
        

        return cell
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        mapView.clear()
    
        animationPolyline = GMSPolyline()
        if let _ = timer{
            timer.invalidate()
            timer = nil
        }
        
        polyline = GMSPolyline()
        path.removeAllCoordinates()
        animationPath = GMSMutablePath()
        i = 0
       
        
       
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
        
        }
        
    
        let currentData = thisWeekDays[indexPath.row]
        currentDisplayDate = currentData
        updateView(date: currentData)
        self.applyForCell(indexPath) { cell in cell.highlight() }

    }
   
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.applyForCell(indexPath) { cell in cell.unhighlight() }
    }
    
    fileprivate func applyForCell(_ indexPath: IndexPath, action: (WeekCollectionViewCell) -> ()) {
        print(indexPath)
        let highlightedCell = calenderView.cellForItem(at: indexPath) as! WeekCollectionViewCell
        action(highlightedCell)
    }
    
}


extension HistoryViewController{
    func setupMap(){
        
         mapView.changeStyle()
        
        var locationManage = CLLocationManager()
        
        if let lat = locationManage.location?.coordinate.latitude, let long = locationManage.location?.coordinate.longitude {
            
            
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
            mapView.camera = camera
        }
        
        
    }
    

    
}


extension HistoryViewController: HandleUserViewDelegate{
    
    func handleOnSwipe() {
        // userLocationCardHeightAnchor.constant += 50
        self.view.layoutIfNeeded()
        //handleTap()
    }
    
    
}


extension HistoryViewController: LocationsFilterDelegate, PolylineStringDelegate{
    
    
    func finalLocations(locations: [LocationDataModel]) {
        //            self.plotMarkersInMap(location: locations)
        var finalLocations = locations
        
        
        
        finalLocations.sort(by: { (first, second) -> Bool in


            if let firstDate = first.lastSeen , let secondDate = second.lastSeen{
                return  firstDate.compare(secondDate) == .orderedAscending


            }

            return false
        })
        
        print(finalLocations)
        self.plotMarkersInMap(location: finalLocations)
        
        
        
    }
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        drawPath(coordinates: coordinates)
    }
    
    
    
}

