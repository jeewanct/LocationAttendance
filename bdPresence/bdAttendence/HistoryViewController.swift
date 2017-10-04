//
//  HistoryViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 25/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
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

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        var insets = self.calenderView.contentInset
//        //let value = (self.calenderView.frame.size.height - (self.calenderView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height)
//        insets.top = 0.0
//        insets.bottom = 0.0
//        insets.left = 0.0
//        insets.right = 0.0
//        self.calenderView.contentInset = insets
        
        //alenderView.contentSize = CGSize(width: 40.0, height: 40.0)
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
            //updateView()
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
        
        progressBar.maxValue = CGFloat((officeEndHour - officeStartHour) * 3600)
        progressBar.innerRingColor = APPColor.newGreen
        
        createbarchartView(date: date)
    }
    
    func createbarchartView(date:Date){
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        
        
        // submit a task to the queue for background execution
        queue.async() {
          let object = UserDayData.getFrequencyLocationBarData(date:date)
            DispatchQueue.main.async() {
                let totalTime = object.getElapsedTime()!
//                if totalTime == 0{
//                    self.swipeUpButton.isHidden = true
//                }else{
//                    self.swipeUpButton.isHidden = false
//                }
                self.progressBar.setProgress(value: CGFloat(totalTime), animationDuration: 2.0) {
                    
                }
                let (hour,min,_) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime))
                
                let myMutableString =  NSMutableAttributedString(
                    string: "\(self.timeText(hour)):\(self.timeText(min))",
                    attributes: [NSFontAttributeName:APPFONT.DAYHOUR!])
                let seconndMutableString =  NSMutableAttributedString(
                    string: " Total hours",
                    attributes: [NSFontAttributeName:APPFONT.DAYHOURTEXT!])
                myMutableString.append(seconndMutableString)
                self.timeLabel.attributedText = myMutableString
                self.startLabel.text = self.getDateInAMPM(date: Date(timeIntervalSince1970: object.getStartTime()!))
                self.endLabel.text = self.getDateInAMPM(date: Date(timeIntervalSince1970: object.getEndTime()!))
               self.addressLabel.numberOfLines = 0
               self.addressLabel.lineBreakMode = .byWordWrapping
               self.addressLabel.adjustsFontSizeToFitWidth = true
                self.addressLabel.text = object.getLastCheckInAddress()?.capitalized
                self.updateFrequencyBar(mData: object)
            }
            
        }
        
        
        
        
    }
    
    func getDateInAMPM(date:Date)->String{
        print(date)
        let timeFormatter = DateFormatter()
        //timeFormatter.dateStyle = .none
        
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from:date)
        
    }
    
    
    func updateFrequencyBar(mData:FrequencyBarGraphData) {
        var mRectList = [CGRect]()
        
        let viewWidth = barchartView.frame.size.width;
        let viewHeight =
            barchartView.frame.size.height;
        let maxDuration = mData.getEndTime()! - mData.getStartTime()!;
        let widthPerDuration =  viewWidth / CGFloat(maxDuration);
        for  duration in mData.graphData {
            
            let left = Int(widthPerDuration * CGFloat(duration.getStartTime() - mData.getStartTime()!));
            var right = Int(CGFloat(left) + (widthPerDuration * CGFloat(duration.getEndTime() - duration.getStartTime())));
            let top = 0;
            let bottom = viewHeight;
            right = right - left < 1 ?  1 :  right - left;
            
            let rect = CGRect(x: left, y: top, width: right, height: Int(bottom))
            //print(rect)
            mRectList.append(rect)
        }
        let view = FrequencyGraphView(frame: CGRect(x: 0, y: 0, width: barchartView.frame.width, height: barchartView.frame.height), data: mRectList)
        barchartView.addSubview(view)
        
    }
    
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    func currentTime(time:TimeInterval) -> String {
        
        //        if let value = UserDefaults.standard.value(forKey: "LastCheckinTime") as? Date {
        //            date = value
        //        }
        let date = Date(timeIntervalSince1970: time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(timeText(hour)):\(timeText(minutes))"
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

