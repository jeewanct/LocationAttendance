//
//  AssignmentDetailViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 29/11/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit

class AssignmentDetailViewController: UIViewController {
    var viewPager:ViewPagerControl!
    var tabView:ViewPagerControl!
    
    
   var imagesTableDataArray = ["Image 01","Image 02","Image 03","Image 04"];
    var timeLineTableArray = ["OutGoingCall","Image Captured","Assignment Started"]
    
    @IBOutlet weak var timeLineTableView: UITableView!
    @IBOutlet weak var imagesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabbarView()
        createViewPager()
        
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.isHidden = true
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(AssignmentDetailViewController.saveAction(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
    }
    func saveAction(_:UIButton){
        
    }
    
    func createTabbarView(){
        let image1 = ["notes","attachments","signature"]
        let image2 = ["notes","attachments","signature"]
        tabView = ViewPagerControl(images: image2, selectedImage: image1)
        //ViewPagerControl(items: data)
        tabView.type = .image
        tabView.frame = CGRect(x: 0, y: ScreenConstant.height - 114, width: ScreenConstant.width, height: 50)
        
        
        tabView.selectionIndicatorColor = UIColor.white
        //tabView.showSelectionIndication = false
        self.view.addSubview(tabView)
        
        tabView.indexChangedHandler = { index in
            
            self.tabChanger(segment: index)
            
        }
        
    }
    func createViewPager(){
        let data = ["General","History"]
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
        
        
        
        
    }
    
    func segmentControl(index:Int){
        switch(index){
        case 0:
            timeLineTableView.isHidden = true
        case 1:
            timeLineTableView.isHidden = false
        default:
            break

        }
    }
    
    
    func tabChanger(segment:Int){
        switch segment {
        case 0:
            break;
            //mapView.isHidden = true
        case 1:
            break
            //mapView.isHidden = false
            
        default:
            break
        }
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


extension AssignmentDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return timeLineTableArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! TimeLineTableViewCell
            cell.taskTitleLabel.text = timeLineTableArray[indexPath.row]
            cell.taskImageView.image = UIImage(named: "bookmark")
            cell.taskTimeLabel.text = "11/11/16 21:30"
            if indexPath.row == 0{
                cell.upLineView.isHidden = true
                cell.downLineView.isHidden = false
                
            }else if indexPath.row == timeLineTableArray.count - 1 {
                cell.upLineView.isHidden = false
               cell.downLineView.isHidden = true
            }else{
                cell.upLineView.isHidden = false
                cell.downLineView.isHidden = false
            }
            return cell
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
    
    
    
}
