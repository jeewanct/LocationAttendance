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
let searchController = UISearchController(searchResultsController: nil)
    
      var viewPager:ViewPagerControl!
    
    @IBOutlet weak var searchTable: UITableView!
    lazy   var searchBars:UISearchBar = UISearchBar(frame:
        
        CGRect(x:0, y:0, width:ScreenConstant.width - 100, height:20))

    var tasks : Results<RMCAssignmentObject>!
    var searchResult : Results<RMCAssignmentObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = getTasks("s")
        configureSearchbar()
        createViewPager()
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(UINib(nibName: "AssignmentTableCell", bundle: nil), forCellReuseIdentifier: "assignmentCell")
        // Do any additional setup after loading the view.
    }
    
    
    func getTasks(_ status: String) -> Results<RMCAssignmentObject> {
        let realm = try! Realm()
        tasks = realm.objects(RMCAssignmentObject.self)
        //        switch status{
        //            case "Downloaded":
        //            tasks = tasks.filter("status = true")
        //        default:break
        //        }
        
        return tasks
        
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
    
    
    func configureSearchbar(){
        
        
        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
//        definesPresentationContext = true
//        searchController.dimsBackgroundDuringPresentation = false
//        
//        // Setup the Scope Bar
//        searchController.searchBar.scopeButtonTitles = ["New", "In-Progress", "Completed"]
//        
//        searchController.searchBar.showsBookmarkButton = true
//        tableView.tableHeaderView = searchController.searchBar
        searchBars.searchBarStyle = .minimal
        searchBars.setPositionAdjustment(UIOffset.init(horizontal: 0, vertical: 0), for: UISearchBarIcon.search)
        searchBars.showsBookmarkButton = true
        
    //self.navigationItem.backBarButtonItem?.setBackgroundImage(UIImage(named:"back"), for: UIControlState.normal, style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.defaultPrompt)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backbuttonAction(sender:)))
        self.navigationItem.titleView = searchBars
        
//        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: "selector")
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let control = UISegmentedControl(items: ["Seg1","Seg2","Seg3"])
//        control.addTarget(self, action: "valueChanged:", for: UIControlEvents.valueChanged)
//        if(section == 0){
//            return control;
//        }
//        return nil;
//    }
//    
//    func valueChanged(segmentedControl: UISegmentedControl) {
//        print("Coming in : \(segmentedControl.selectedSegmentIndex)")
////        if(segmentedControl.selectedSegmentIndex == 0){
////            self.data = self.data0
////        } else if(segmentedControl.selectedSegmentIndex == 1){
////            self.data = self.data1
////        } else if(segmentedControl.selectedSegmentIndex == 2){
////            self.data = self.data2
////        } else {
////            self.data = data0
////        }
//        self.tableView.reloadData()
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44.0
//    }
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

extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell") as! AssignmentTableCell
        cell.configureWithTask(task)
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }

}
