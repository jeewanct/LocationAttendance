//
//  AwsManager.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 09/12/16.
//  Copyright © 2016 raremediacompany. All rights reserved.
//

import Foundation

import AWSS3

func configAwsManager(poolId:String = "ap-northeast-1:a0c55baf-0ee2-4ffa-90e8-901d3b14c45b",region:AWSRegionType = AWSRegionType.apNortheast1){
    
    
    // configure authentication with Cognito
    let CognitoPoolID = poolId
    let Region = region
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:Region,
                                                            identityPoolId:CognitoPoolID)
    
    let configuration = AWSServiceConfiguration(region:Region, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
}

func sendFile(imageName:String,image:UIImage, extention:String,S3BucketName:String){
    let ext = extention
    let fileName = imageName + "." + ext
    let uploadRequest = AWSS3TransferManagerUploadRequest()
    do {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if let pngImageData = UIImageJPEGRepresentation(image, 0.1) {
            try pngImageData.write(to: fileURL, options: .atomic)
        }
        
        uploadRequest?.body = fileURL
        uploadRequest?.key = fileName
        uploadRequest?.bucket = S3BucketName
        //uploadRequest?.contentType = "image/" + ext
    } catch {
        print("failed")
    }
    
    // build an upload request
    
    
    // upload
    let transferManager = AWSS3TransferManager.default()
    transferManager?.upload(uploadRequest).continue({ (task) -> Any? in
        if let error = task.error {
            print("Upload failed ❌ (\(error))")
        }
        
        if let exception = task.exception {
            print("Upload failed ❌ (\(exception))")
        }
        
        if task.result != nil {
            let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(fileName)")!
            //let image = UIImage(data: NSData(contentsOf: s3URL as URL)! as Data)
            print("Uploaded to:\n\(s3URL)")
        }
        else {
            print("Unexpected empty result.")
        }
        return nil
        
    })
    //.continue { (task) -> AnyObject! in
    
    
    
}
