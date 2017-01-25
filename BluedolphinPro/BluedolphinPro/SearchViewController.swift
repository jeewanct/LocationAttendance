//
//  SearchViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 07/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift


class SearchViewController: UIViewController {
    @IBOutlet weak var searchTable: UITableView!
    var tasks : Results<RMCAssignmentObject>!
    var searchResult : List<RMCAssignmentObject>!
    var viewPager:ViewPagerControl!
    lazy   var searchBars:UISearchBar = UISearchBar(frame:
        CGRect(x:0, y:0, width:ScreenConstant.width - 100, height:20))
    var searchActive : Bool = false
    var currentStatus:CheckinType = .Assigned
    var changeSegment : SegmentChanger?
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl(index: 0)
        configureSearchbar()
        createViewPager()
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(UINib(nibName: "AssignmentTableCell", bundle: nil), forCellReuseIdentifier: "assignmentCell")
        searchTable.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func getTasks(ascendingFlag:Bool = true){
        let realm = try! Realm()
        tasks = realm.objects(RMCAssignmentObject.self)
        tasks = tasks.filter("status = %@",currentStatus.rawValue)
        tasks = tasks.sorted(by: [
            SortDescriptor(property: "assignmentStartTime", ascending: ascendingFlag),
            //            SortDescriptor(property: "created", ascending: false),
            ])
        searchTable.reloadData()
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
        
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(sender:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
//        
//        self.view.addGestureRecognizer(swipeLeft)
//        self.view.addGestureRecognizer(swipeRight)
        
    }
    
//    func swiped(sender:UISwipeGestureRecognizer){
//        if let swipeGesture = sender as? UISwipeGestureRecognizer{
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.right:
//                viewPager.setSelectedSegmentIndex(viewPager.selectedSegmentIndex + 1 > 2 ? 2:viewPager.selectedSegmentIndex + 1, animated: true)
//            case UISwipeGestureRecognizerDirection.left:
//                viewPager.setSelectedSegmentIndex(viewPager.selectedSegmentIndex - 1 < 0 ? 0:viewPager.selectedSegmentIndex - 1, animated: true)
//                print("left swipe")
//            default:
//                print("other swipe")
//            }
//        }
//    }
    
    func segmentControl(index:Int){
        switch index {
        case 0:
            currentStatus = .Downloaded
            
        case 1:
            currentStatus = .Inprogress
        case 2:
            currentStatus = .Submitted
        default:
            break
        }
        getTasks()
//        showCheckinMarkers(tasks)
        
    }
    
    
    func configureSearchbar(){
        
        
        // Setup the Search Controller
        searchBars.delegate = self
        searchBars.searchBarStyle = .minimal
        searchBars.setPositionAdjustment(UIOffset.init(horizontal: 0, vertical: 0), for: UISearchBarIcon.search)
        searchBars.showsBookmarkButton = true
        searchBars.becomeFirstResponder()
        
    //self.navigationItem.backBarButtonItem?.setBackgroundImage(UIImage(named:"back"), for: UIControlState.normal, style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.defaultPrompt)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backbuttonAction(sender:)))
        self.navigationItem.titleView = searchBars
        
//        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: "selector")
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }

    func backbuttonAction(sender:Any){
        self.navigationController!.popViewController(animated: true)
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
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        searchResult = tasks.filter({( candy : RMCAssignmentObject) -> Bool in
//            let categoryMatch = (scope == "New") || (candy.category == scope)
//            return categoryMatch && candy.name.lowercased().contains(searchText.lowercased())
//        })
        searchTable.reloadData()
    }

}

//MARK: Search delegate
extension SearchViewController:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        searchTrainlingContraint.constant = -80
        //        UIView.animateWithDuration(0.5) {
        //            self.view.layoutIfNeeded()
        //        }
    }
    //
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    //    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    //        searchActive = false;
    //        taskTableview.reloadData()
    //    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        filtered = result.filter {
        //            $0.jobNumber!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        //        }
        //        if(filtered.count == 0){
        //            searchActive = false;
        //        } else {
        //            searchActive = true;
        //        }
        //        self.taskTableview.reloadData()
        //
        
        
        if searchBar.text!.isEmpty{
            searchActive = false
            
            searchTable.reloadData()
        } else {
            //println(" search text %@ ",searchBar.text as NSString)
            searchActive = true
            searchResult = List<RMCAssignmentObject>()
            
            for obj in tasks {
                guard let address = obj.assignmentAddress else {
                    return
                }
                if let assignmentdetail = obj.assignmentDetails?.parseJSONString as? NSDictionary{
                    
                    guard let jobnumber = assignmentdetail["jobNumber"] as? String else {
                        return
                    }
                    
                   let currentString = address + " " + jobnumber
                    //println("  text %@ ",currentString.lowercaseString)
                    if currentString.lowercased().range(of: searchText.lowercased())  != nil {
                        searchResult.append(obj)
                    }
                }
                
            }
            searchTable.reloadData()
            
        }
        
    }
    
}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return searchResult.count
        }
        return tasks.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var task : RMCAssignmentObject!
        if(searchActive) {
            task = searchResult[indexPath.row]

        }
        else {
            task = tasks[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell") as! AssignmentTableCell
        cell.configureWithTask(task)
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task : RMCAssignmentObject!
        if(searchActive) {
            task = searchResult[indexPath.row]
            
        }
        else {
            task = tasks[indexPath.row]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentDetail") as? AssignmentDetailViewController
        controller?.assignment = task
        controller?.changeSegment = self
        self.navigationController?.pushViewController(controller!, animated: true)
        //self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }

}
extension SearchViewController :SegmentChanger{
    func moveToSegment(_ pos:String){
        switch pos {
        case CheckinType.Downloaded.rawValue :
            
            viewPager.setSelectedSegmentIndex(0, animated: false)
            segmentControl(index: 0)
        case CheckinType.Inprogress.rawValue:
            viewPager.setSelectedSegmentIndex(1, animated: false)
            segmentControl(index: 1)
        case CheckinType.Submitted.rawValue:
            viewPager.setSelectedSegmentIndex(2, animated: false)
            segmentControl(index: 2)
        default:
            viewPager.setSelectedSegmentIndex(0, animated: false)
            segmentControl(index: 1)
            
        }
        
        
    }
    
}
