//
//  GalleryViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 15/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<PHAsset>!
    var index: Int = 0
    let reuseIdentifier = "galleryCell"
    var albumFound : Bool = false
  
    var assetThumbnailSize:CGSize!

    @IBOutlet weak var thumbNailCollectionView: UICollectionView!
    @IBOutlet weak var fullscreenCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        
        thumbNailCollectionView.delegate = self
        thumbNailCollectionView.dataSource = self
        
        thumbNailCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        fullscreenCollectionView.delegate = self
        fullscreenCollectionView.dataSource = self
        fullscreenCollectionView.isPagingEnabled = true
        
        fullscreenCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.backBarButtonItem?.setBackgroundImage(UIImage(named:"back"), for: UIControlState.normal, style: UIBarButtonItemStyle.plain, barMetrics: UIBarMetrics.defaultPrompt)
        fullscreenCollectionView.reloadData()
        thumbNailCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let layout = self.thumbNailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        
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

extension GalleryViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if(self.photosAsset != nil){
            count = self.photosAsset.count
        }
        return count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        
        //Modify the cell

        let asset = self.photosAsset[indexPath.row] 
        // Create options for retrieving image (Degrades quality if using .Fast)
        //        let imageOptions = PHImageRequestOptions()
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
       
        if collectionView == fullscreenCollectionView{
            let screenSize: CGSize = UIScreen.main.bounds.size
            let targetSize = CGSize(width: screenSize.width, height: screenSize.height)
            
            let imageManager = PHImageManager.default()
            
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: {
                    (result, info)->Void in
                    cell.setThumbnailImage(result!)
                })
        
        }else{
            
            PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info)in
                if let image = result {
                    cell.setThumbnailImage(image)
                }
            })
           
        }
        
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout methods
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//        return 4
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
//        return 1
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == thumbNailCollectionView {
           
    
                    self.fullscreenCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)

        }else{
                                self.thumbNailCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
        
    }
//    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
//    {
//        if collectionView == thumbNailCollectionView {
//            let size = ScreenConstant.width/3
//            return CGSize(width: 50, height: size)
//        }else{
//            
//        }
//        
//    }
    
    
  
    
}
