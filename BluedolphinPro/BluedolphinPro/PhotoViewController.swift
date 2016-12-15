//
//  PhotoViewController.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 15/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import UIKit
import Photos



class PhotoViewController: UIViewController, UINavigationControllerDelegate {
    var albumName = "NIKH-8690"
    let reuseIdentifier = "galleryCell"
    var alertTextfield = UITextField()
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize!
    
    
    @IBOutlet var noPhotosLabel: UILabel!
    
    //Actions & Outlets
   
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)   }
    //    @IBAction func btnPhotoAlbum(sender : AnyObject) {
    //        let picker : UIImagePickerController = UIImagePickerController()
    //        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    //        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
    //        picker.delegate = self
    //        picker.allowsEditing = false
    //        self.presentViewController(picker, animated: true, completion: nil)
    //    }
    
    @IBOutlet var collectionView : UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //        let apppointdate =  timestampToDate((workdictHolder?.appointmentTime)!)
        //        durationLabel.text = apppointdate.dateDiff(NSDate())
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        }else{
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder:PHObjectPlaceholder!
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
                                                   completionHandler: {(success, error)in
                                                    if(success){
                                                        print("Successfully created folder")
                                                        self.albumFound = true
                                                        let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                                                        self.assetCollection = collection.firstObject!
                                                    }else{
                                                        print("Error creating folder")
                                                        self.albumFound = false
                                                    }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        // Get size of the collectionView cell for thumbnail image
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        }
        
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
        self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
        
        
        if let photoCnt = self.photosAsset?.count{
            if(photoCnt == 0){
                self.noPhotosLabel.isHidden = false
            }else{
                self.noPhotosLabel.isHidden = true
            }
        }
        self.collectionView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showScrollView"){
            if let controller:GalleryViewController = segue.destination as? GalleryViewController{
                if let cell = sender as? UICollectionViewCell{
                    if let indexPath: IndexPath = self.collectionView.indexPath(for: cell){
                        controller.index = (indexPath as NSIndexPath).item
                        controller.photosAsset = self.photosAsset
                        controller.assetCollection = self.assetCollection
                    }
                }
            }
        }
    }
    
    
  
    
    func showAlert(_ message : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (action) in
            return        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true) {
        }
    }
    
    func showLoader(){
        AlertView.sharedInstance.setLabelText("Saving Image")
        AlertView.sharedInstance.showActivityIndicator(self.view)
        
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            AlertView.sharedInstance.hideActivityIndicator(self.view)
            //self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}

//MARK: UICollectionViewDataSource & delegatesMethods
extension PhotoViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        let asset: PHAsset = self.photosAsset[(indexPath as NSIndexPath).item] 
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        //        let imageOptions = PHImageRequestOptions()
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info)in
            if let image = result {
                cell.setThumbnailImage(image)
            }
        })
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showScrollView", sender: collectionView.cellForItem(at: indexPath))
    }
    
}
