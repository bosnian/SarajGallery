//
//  ImageManager.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import Photos
import Async

class ImageManager {
    
    private let manager = PHImageManager.defaultManager()
    
    private var images = [ImageModel]()
    
    init(){
    }
    
    class func authorize(authorized:()->(), unauthorized:()->()){
        
        if ( PHPhotoLibrary.authorizationStatus() != .Authorized) {
            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                Async.main {
                    
                    if ( authorizationStatus == .Authorized){
                        authorized()
                    } else {
                        unauthorized()
                    }
                }
                
            }
        } else {
            authorized()
        }
    }
    
    func loadAllImages(progress:()->()){
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: PHFetchOptions()){
            
            let imageRequestOptions = PHImageRequestOptions()
            imageRequestOptions.deliveryMode = .FastFormat
            
            for i in 0...fetchResult.count-1 {
                if let asset: PHAsset = fetchResult[i] as? PHAsset{
                    manager.requestImageForAsset(asset, targetSize: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height), contentMode: .AspectFill, options: imageRequestOptions, resultHandler: { (image, dict) in
                        if image != nil {
                            
                            self.images.append(ImageModel(img: image!,title: asset.originalFilename,asset: asset))
                            progress()
                            
                        }
                    })
                }
            }
        }
    }
    
    func loadHighResImage(id: Int, success: ()->()){
        
        if (  self.images[id].isHighRes == true ){
            success()
            return
        }
        
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.deliveryMode = .HighQualityFormat
        
        manager.requestImageForAsset(images[id].asset!, targetSize: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height), contentMode: .AspectFit, options: imageRequestOptions, resultHandler: { (image, dict) in
            if image != nil {
                self.images[id].img = image
                self.images[id].isHighRes = true
                success()
            }
        })
    }
    
    func getImageAdIndex(id: Int)-> ImageModel?{
        if id >= images.count {
            return nil
        } else {
            return images[id]
        }
    }
    
    func getAllImages()->[ImageModel]{
        return images
    }
    
    func getImageCount()->Int{
        return images.count
    }
}
