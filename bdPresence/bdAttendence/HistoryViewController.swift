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
    var animate = false
    
   
    
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuAction(sender:)))
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: APPFONT.DAYHEADER!]
        self.navigationItem.title = Date().formattedWith(format: "MMMM yyyy")
        hideUpperButton()
    }
    
   @objc func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
    }
    
    func setupObservers(){
         NotificationCenter.default.addObserver(self, selector: #selector(HistoryViewController.getDataFromCheckin), name: NSNotification.Name(rawValue: "CheckInsFromServerWithZeroElements"), object: nil)
    }
    
   @objc func getDataFromCheckin(){

        
        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkers(date: currentDisplayDate)
        
        //updateView(date: currentDisplayDate)
        
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
        
        activityIndicator.removeActivityIndicator(activityIndicator: activityIndicator)
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
            calenderView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.bottom)
        }
    }
}



extension HistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.width/7, height:collectionView.frame.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//       // let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
////        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
////        layout.minimumInteritemSpacing = 0
////        layout.minimumLineSpacing = 0
////        layout.invalidateLayout()
//        
//        // Set your item size here
//    }
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
        //updateView(date: currentData)
        self.applyForCell(indexPath) { cell in cell.highlight() }
        animate = false
        

        
        if let data = UserDayData.getLocationDataFromServer(date: currentData){
            let headerData = ClusterDataFromServer.getHeaderData(locationData: data)
            dataFromServer(locationData: data, headerData: headerData)
        }else{
            getDataFromServer(currentDate: currentData)
        }
        
        
        

        if let screenFlag = UserDefaults.standard.value(forKeyPath: "AlreadyCheckin") as? String{
            
            if screenFlag == "2" && !RMCNotifier.shared.getShiftRunningStatus(){
                if UserDayData.checkIfPendingCheckinsFound(date: currentData){
                    getDataFromServer(currentDate: currentData)
                }
            }else{
                if LogicHelper.compareDates(previous: currentData){
                    getDataFromServer(currentDate: currentData)
                }
            }
            
        }
        

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
        //self.view.showActivityIndicator(activityIndicator: activityIndicator)
        selectedDate = date
        
        let locationFilters = LocationFilters()
        locationFilters.delegate = self
        locationFilters.plotMarkers(date: date)
        
        
    }
 
    
    
    
    func drawPath(coordinates: [CLLocationCoordinate2D]){
        mapView.drawPath(coordinates: coordinates)
       // animatePolyline()
        animate = true
    }

    func clearMapData(){
        mapView.clear()
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        if let _ = pullController{
            self.removePullUpController(pullController, animated: true)
            
        }
    }
}

extension HistoryViewController: LocationsFilterDelegate, PolylineStringDelegate{
    func onFailure(type: ErrorMessages) {
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        AlertsController.shared.displayAlertWithoutAction(whereToShow: self, message: type.rawValue)
    }

    func finalLocations(locations: [LocationDataModel]) {
       // self.plotMarkersInMap(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        self.view.removeActivityIndicator(activityIndicator: activityIndicator)
        let allLocations = UserPlace.getGeoTagData(location: LogicHelper.shared.sortOnlyLocations(location: locations))
        mapView.addMarkersInMap(allLocations: allLocations)
        
        
        let locations = ClusterDataFromServer.convertDataToUserModel(locationData: LogicHelper.shared.sortGeoLocations(locations: allLocations).reversed())
        let headerData = ClusterDataFromServer.getHeaderData(locationData: locations)
        dataFromServer(locationData: locations, headerData: headerData)
    
    }
    
    func drawPolyline(coordinates: [CLLocationCoordinate2D]) {
        drawPath(coordinates: coordinates)
    }
    
    
    
}

extension HistoryViewController: ServerDataFromClusterDelegate{
    func dataFromServer(locationData: [UserDetailsDataModel], headerData: [String]) {
        
        clearMapData()
        pullController = UIStoryboard(name: "NewDesign", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        pullController.screenType = LocationDetailsScreenEnum.historyScreen
        
        mapView.addMarkersInMap(allLocations: locationData)
        pullController.userDetails = locationData
        pullController.distanceArray = headerData
        self.addPullUpController(pullController, initialStickyPointOffset: UIScreen.main.bounds.height * 0.3, animated: true)
        
        let polyLine = DrawPolyLineInMap()
        polyLine.delegate = self
        polyLine.getPolyline(location: locationData.reversed())
        
        
    }
    
    
    
}


extension HistoryViewController: ServerResponseDelegate{
    
    func getDataFromServer(currentDate: Date){
        let serverData = checkinFromServerManager()
        serverData.delegate = self
        serverData.getClusterData(query: GetClusteringFromServer.quoteString(date: currentDate), date: currentDate)
    }
    
    func successData<T>(data: T) {
        
        if let locationData = data  as? [UserDetailsDataModel]{
            let headerData = ClusterDataFromServer.getHeaderData(locationData: locationData)
            dataFromServer(locationData: locationData, headerData: headerData)
        }
        
        
    }
    
    func errorData<T>(error: T) {
        
        if let getError = error as? String{
            if getError == "No Data"{
                getDataFromCheckin()
                
            }
        }
    }
}
