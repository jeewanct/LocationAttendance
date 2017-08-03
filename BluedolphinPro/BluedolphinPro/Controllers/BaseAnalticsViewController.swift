//
//  BaseAnalticsViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 20/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit

class GraphValue {
    var date:Date?
    var completedData:Int
    init(date:Date,complete:Int) {
      self.date = date
    self.completedData = complete
    }
}

func getDateFromcomponent(day:Int,month:Int,year:Int)->Date{
    var component = DateComponents()
    component.day = day
    component.month = month
    component.year = year
    component.timeZone = TimeZone(abbreviation: "UTC")
    let date = Calendar.current.date(from: component)
    return date!
    
}
class BaseAnalticsViewController: UIViewController {
       
    var graphDataArray = [GraphValue]()
    
    @IBOutlet weak var graphTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavView(controller: self, title: "My DashBoard")

        graphTableView.delegate = self
        graphTableView.dataSource = self
        graphTableView.register(UINib(nibName: "BarGraphTableViewCell", bundle: nil), forCellReuseIdentifier: "barChart")
        let model = BaseAnalytics()
       model.getBaseAnaltics { (result) in
        for data in result{
            let dataDict = data as! NSDictionary
            guard let idDict = dataDict["_id"] as? NSDictionary else {
                return
            }
            
            guard let day = idDict["date"] as? Int else {
                return
            }
            guard let month = idDict["month"] as? Int else {
                return
            }
            guard let year = idDict["year"] as? Int else {
                return
            }
            
            for i in 0...7{
                let graphValue = GraphValue(date: Date().getDateFromCurrent(val: -i).asDate, complete: i+7)
                self.graphDataArray.append(graphValue)
            }
//            let dateValue = getDateFromcomponent(day: day, month: month, year: year)
//            if let completed = dataDict["completed"] as? Int {
//                let graphValue = GraphValue(date: dateValue, complete: completed)
//                self.graphDataArray.append(graphValue)
//            }
        }
        self.graphTableView.reloadData()
        
        }

        // Do any additional setup after loading the view.
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
extension BaseAnalticsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "barChart") as! BarGraphTableViewCell
        cell.configureCell(title: "Assignment Completed", dateString: " March 14 to March 21", barData: graphDataArray)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showDetails", sender: self)
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentDetail") as? AssignmentDetailViewController
//        controller?.assignment = tasks[indexPath.row]
//        controller?.changeSegment = self
//        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
}
