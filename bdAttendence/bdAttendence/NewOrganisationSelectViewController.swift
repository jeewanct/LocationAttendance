//
//  NewOrganisationSelectViewController.swift
//  bdAttendence
//
//  Created by Raghvendra on 21/06/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
import RealmSwift




class NewOrganisationSelectViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
     var accessTokensList:Results<AccessTokenObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
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

extension NewOrganisationSelectViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accessTokensList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let task = accessTokensList[indexPath.row]
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "organisationCell", for: indexPath as IndexPath) as! OrganizationCollectionViewCell
        
    
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.organizationNameLabel.numberOfLines = 0
        cell.organizationNameLabel.font = APPFONT.BODYTEXT
        cell.organizationNameLabel.text = task.organizationName.capitalized
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
         let cell = collectionView.cellForItem(at: indexPath) as! OrganizationCollectionViewCell
        cell.checkImage.image = #imageLiteral(resourceName: "org_selection")
        let task = accessTokensList[indexPath.row]
        let orgId  = task.organizationId
        UserDefaults.standard.set(orgId, forKey: UserDefaultsKeys.organizationId.rawValue)
        getUserData()
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = destVC
    }
}
