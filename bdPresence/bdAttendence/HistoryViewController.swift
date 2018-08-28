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
    var selectedDate = Date()
    @IBOutlet weak var mapView: GMSMapView!
    var activityIndicator = ActivityIndicatorView()
  
    /* Changes made from 10th July '18 */
    
    
    var pullController: SearchViewController!
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCalendar()
        setupObservers()
        setupMap()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectTodayDateInCalendar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearMemory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func showTimeLineView(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "timeLine") as? UINavigationController
        let topcontroller = controller?.topViewController as! TimeLineViewController
        topcontroller.currentDate = self.currentDisplayDate
        self.present(controller!, animated: true, completion: nil)
        
    }
    

}

extension HistoryViewController{
    
    func setupNavigation(){
        navigationController?.removeTransparency()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: APPFONT.DAYHEADER!]
        self.navigationItem.title = Date().formattedWith(format: "MMMM yyyy")
        hideUpperButton()
    }
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryViewController.discardFakeLocations), name: NSNotification.Name(rawValue: LocalNotifcation.RMCPlacesFetched.rawValue), object: nil)
    }
    
    func discardFakeLocations(){
        updateView()
    }
    
    func hideUpperButton(){
        self.swipeUpButton.isHidden = true
        self.swipeUpButton.frame.size.width = 0
        currentDisplayDate = Date().dayStart()!
    }
    
    func clearMemory(){
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
        }
        if let _ = self.timer{
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    
}

//MARK: Setup Calendar

extension HistoryViewController{
    
    func setupCalendar(){
        calenderView.delegate = self
        calenderView.dataSource = self
        self.startLabel.font = APPFONT.VERSIONTEXT
        self.endLabel.font = APPFONT.VERSIONTEXT
        getCalenderData()
        calenderView.register(UINib(nibName: "WeekCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weekCell")
    }
    
    func getCalenderData(){
        thisWeekDays =  formattedDaysInThisWeek()
        calenderView.reloadData()
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
    
    
    func selectTodayDateInCalendar(){
        if let index = thisWeekDays.index(of: currentDisplayDate) {
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView(calenderView, didSelectItemAt: indexPath)
            calenderView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.bottom)
        }
    }
}



extension HistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
       // let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.invalidateLayout()
        return CGSize(width: collectionView.frame.width/7, height:collectionView.frame.height) // Set your item size here
    }
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView.frame)
        return thisWeekDays.count
    }

   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let currentData = thisWeekDays[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekCell", for: indexPath) as! WeekCollectionViewCell
        setupHistoryCell(cell: cell, currentData: thisWeekDays[indexPath.row])
        return cell
        
    }
    
    func setupHistoryCell(cell: WeekCollectionViewCell, currentData: Date){
        cell.cellLabel.text = currentData.formattedWith(format: "EEEEE")
        cell.cellLabel.font = APPFONT.DAYCHAR
        cell.dateLabel.text = currentData.formattedWith(format: "d")
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
        

    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clearMapData()
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

//MARK: Setup Map
extension HistoryViewController{
    
    func setupMap(){
        mapView.changeStyle()
        mapView.setupCamera()
    }
    
}

//MARK: Get User History data

extension HistoryViewController{
    func updateView(date:Date = Date()){
        activityIndicator = ActivityIndicatorView()
        self.view.showActivityIndicator(activityIndicator: activityIndicator)
        selectedDate = date
        
        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkers(date: date)
        
        
    }
    
    
    func plotMarkersInMap(location: [LocationDataModel]){
        
        let allLocations = UserPlace.getGeoTagData(location: location)
        //var finalLocations = allLocations
        mapView.addMarkersInMap(allLocations: allLocations)
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        
        if allLocations.count != 0{
            
            pullController = UIStoryboard(name: "NewDesign", bundle: nil)
                .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
            pullController.screenType = LocationDetailsScreenEnum.historyScreen
            
            pullController.selectedDate = selectedDate
            pullController.locationData = LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed()
            
            self.addPullUpController(pullController, animated: true)
            
            let polyLine = PolyLineMap()
            polyLine.delegate = self
            polyLine.getPolyline(location: LogicHelper.shared.sortGeoLocations(locations: allLocations))
        }
        
    }
    
    
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        mapView.drawPath(coordinates: coordinates)
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
    
    func clearMapData(){
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
    }
}

extension HistoryViewController: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure() {
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: "No Checkin found!")
    }
    
    
    
    func finalLocations(locations: [LocationDataModel]) {
        self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
    }
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        drawPath(coordinates: coordinates)
    }
    
    
    
}

