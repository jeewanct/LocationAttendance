//
//  WorkHourViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 18/07/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

class WorkHourViewController: UIViewController {

    @IBOutlet weak var timeClock: UICircularProgressRingView!
    @IBOutlet weak var swipeDown: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var swipedown :UISwipeGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuAction(sender:)))
        let image: UIImage = UIImage(named: "swipe_up")!
        let imageRotated: UIImage =
            UIImage(cgImage: image.cgImage!, scale: 1, orientation: UIImageOrientation.down)
        swipeDown.image = imageRotated
        timeLabel.font = APPFONT.DAYHEADER
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewCheckoutViewController.updateTime(sender:)), name: NSNotification.Name(rawValue: LocalNotifcation.TimeUpdate.rawValue), object: nil)
        
        swipedown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipedown?.direction = .down
 


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        timeClock.maxValue = CGFloat((officeEndHour - officeStartHour) * 3600)
        timeClock.innerRingColor = APPColor.newGreen
        progressUpdate()
    }
    
    
    func progressUpdate(){
        
        if let startTime = UserDefaults.standard.value(forKeyPath: ProjectUserDefaultsKeys.startDayTime.rawValue) as? Date {
            
            let totalTime = startTime.timeIntervalSinceNow
            let (hour,min,_) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime))
            
            let myMutableString =  NSMutableAttributedString(
                string: "\(self.timeText(hour)):\(self.timeText(min))",
                attributes: [NSFontAttributeName:APPFONT.DAYHOUR!])
            let seconndMutableString =  NSMutableAttributedString(
                string: " Total hours",
                attributes: [NSFontAttributeName:APPFONT.DAYHOURTEXT!])
            myMutableString.append(seconndMutableString)
            self.timeLabel.attributedText = myMutableString
            
            timeClock.setProgress(value: CGFloat(totalTime), animationDuration: 3.0, completion: {
                
            })
        }
        
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeText(_ s: Int) -> String {
        return s < 10 ? "0\(s)" : "\(s)"
    }
    
    func handleGesture(sender:UIGestureRecognizer){
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizerDirection.down:
            break
//            case UISwipeGestureRecognizerDirection.left:
//                if pageControl.currentPage < dataArray.count {
//                    pageControl.currentPage = pageControl.currentPage + 1
//                    let value = dataArray[pageControl.currentPage]
//                    updateView(date: value)
//                }
//                
//                
//            case UISwipeGestureRecognizerDirection.right:
//                if pageControl.currentPage >= 0 {
//                    pageControl.currentPage = pageControl.currentPage - 1
//                    let value = dataArray[pageControl.currentPage]
//                    updateView(date: value)
//                }
                
                
            default:
                break
                
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func menuAction(sender:UIBarButtonItem){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowSideMenu"), object: nil)
        
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
