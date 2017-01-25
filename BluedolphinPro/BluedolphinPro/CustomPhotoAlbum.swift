//
//  CustomPhotoAlbum.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 14/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import Photos

class CustomPhotoAlbum {
    
    var albumName = "Flashpod"
    //static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    init(name:String) {
        albumName = name
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let _: AnyObject = collection.firstObject {
                return collection.firstObject            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
            }
        }
    }
    
    func saveImage(_ image: UIImage,completion: @escaping (_ result: String) -> Void) {
        
        if assetCollection == nil {
            // If there was an error upstream, skip the save.
        }
        var assetPlaceholder:PHObjectPlaceholder!
        var localID:String = ""
        PHPhotoLibrary.shared().performChanges({
            if #available(iOS 9.0, *) {
                let options = PHAssetResourceCreationOptions()
                options.originalFilename = "BD_Signature" + Date().timeStamp()
                let newcreation:PHAssetCreationRequest = PHAssetCreationRequest.forAsset()
                newcreation.addResource(with: PHAssetResourceType.photo, data:UIImageJPEGRepresentation(image, 1)!, options: options)
                assetPlaceholder = newcreation.placeholderForCreatedAsset
                
            } else { // < ios 9
                // Fallback on earlier versions
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            }
            
            
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                albumChangeRequest.addAssets([assetPlaceholder!] as NSFastEnumeration)
                
            }
        }, completionHandler: { success, error in
            if success {
                localID = assetPlaceholder.localIdentifier
                //            let assetID =
                //                localID.replacingOccurrences(
                //            of: "/.*", with: "",
                //            options: NSString.CompareOptions.RegularExpressionSearch, range: nil)
                //            let ext = "jpg"
                //            let assetURLStr =
                //            "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"
                
                // Do something with assetURLStr
                completion(localID)
                            }
            
            
        })
        

        
    }
    
    
    func updatePhoto(_ image: UIImage,completion: @escaping (_ result: String) -> Void){
        if assetCollection == nil {
            return   // If there was an error upstream, skip the delete.
        }
        
        
        //let fetchOptions: PHFetchOptions = PHFetchOptions()
        
        //        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        //        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        //
        //        if (fetchResult.lastObject != nil) {
        //
        //            let lastAsset: PHAsset = fetchResult.lastObject as! PHAsset
        //
        //            let arrayToDelete = NSArray(object: lastAsset)
        //
        //            PHPhotoLibrary.sharedPhotoLibrary().performChanges( {
        //                PHAssetChangeRequest.deleteAssets(arrayToDelete)},
        //                                                                completionHandler: {
        //                                                                    success, error in
        ////                                                                    NSLog("Finished deleting asset. %@", (success ? "Success" : error))
        //
        //                                self.saveImage(image)
        //            })
        //
        //
        //    }
        
       self.saveImage(image) { (localId) in
        completion(localId)
        }
    }
    
    func fetchPhoto(localIdentifier:String,completion: @escaping (_ result: UIImage) -> Void){
        
        
        
        
        var storedImage = UIImage()
        //        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
       
        
        if  localIdentifier != "" {
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        if (fetchResult.lastObject != nil) {
            //        let lastAsset: PHAsset = fetchResult.lastObject as! PHAsset
            let screenSize: CGSize = UIScreen.main.bounds.size
            let targetSize = CGSize(width: screenSize.width, height: screenSize.height)
            
            let imageManager = PHImageManager.default()
            if let asset = fetchResult.lastObject{
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options:nil, resultHandler: {
                    (result, info)->Void in
                    storedImage = result!
                    completion(storedImage)
                    
                })
            }
            
        }
        //    else {
        //       return UIImage()
        //    }
        
        
        }
        
        
    }
    
    func imageCountInAlbum() ->Int{
        return assetCollection.estimatedAssetCount
    }
    
    
    
}
