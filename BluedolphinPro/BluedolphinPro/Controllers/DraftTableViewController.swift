//
//  DraftTableViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 17/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit
import RealmSwift

class DraftTableViewController: UITableViewController {
    var drafts : Results<DraftAssignmentObject>!
    var menuView :CustomNavigationDropdownMenu!
    override func viewDidLoad() {
        super.viewDidLoad()

         createNavView(controller: self, title: "Drafts")
        
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func getDrafts(){
        let realm = try! Realm()
        drafts = realm.objects(DraftAssignmentObject.self)
        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        getDrafts()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let data = drafts{
           return data.count
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftCell", for: indexPath)
        let draftObject = drafts[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 17)
        cell.detailTextLabel?.textColor = UIColor.black
        cell.detailTextLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 17)
        cell.detailTextLabel?.numberOfLines = 3
        cell.textLabel?.text = draftObject.jobNumber
        cell.detailTextLabel?.text = draftObject.draftDescription?.toProper
        
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = drafts[indexPath.row]
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "selfAssignNav") as! UINavigationController
        let controller = navController.topViewController as! CreateAssignmentViewController
        controller.draftObject = object
        controller.draftFlag = true
        self.present(navController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
