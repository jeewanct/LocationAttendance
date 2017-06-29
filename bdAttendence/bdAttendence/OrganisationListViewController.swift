//
//  OrganisationListViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 12/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

import RealmSwift
import BluedolphinCloudSdk
class OrganisationListViewController: UIViewController {

    @IBOutlet weak var organisationList: UITableView!
    var accessTokensList:Results<AccessTokenObject>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        organisationList.delegate = self
        organisationList.dataSource = self
        // Do any additional setup after loading the view.
        organisationList.reloadData()
        organisationList.tableFooterView = UIView()
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

extension OrganisationListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessTokensList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = accessTokensList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "organisationCell") as! OrganisationCell
        //setCardView(view: cell)
        //cell.accessoryType = .disclosureIndicator
        cell.organisationNameLabel.text = task.organizationName.capitalized
        //cell.textLabel?.textAlignment = .center
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = accessTokensList[indexPath.row]
        let orgId  = task.organizationId
        UserDefaults.standard.set(orgId, forKey: UserDefaultsKeys.organizationId.rawValue)
        getUserData()
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = destVC
        //self.performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    func setCardView(view : UIView){
        
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.cornerRadius = 1;
        view.layer.shadowRadius = 1;
        view.layer.shadowOpacity = 0.5;
        
    }
}


