//
//  TutorialController.swift
//  bdPresence
//
//  Created by Raghvendra on 10/07/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import UIKit
import BluedolphinCloudSdk
class TutorialController: UIViewController{
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var pager: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        
    }
    
    func setupController(){
        
        loginButton.layer.cornerRadius = UIScreen.main.bounds.height * 0.07 / 2
        
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 1.0
    }
    
    
}


extension TutorialController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as! TutorialControllerCell
        return cell
    }
    
}

extension TutorialController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width)
        //pager.currentPage = pageNumber
    }
}

class TutorialControllerCell: UICollectionViewCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cell.backgroundView?.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
        
        self.applyGradient(isTopBottom: true, colorArray: [APPColor.BlueGradient,APPColor.GreenGradient])
    }
    
}
