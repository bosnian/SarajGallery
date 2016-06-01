//
//  PHAsset+Extension.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import Photos

// http://stackoverflow.com/a/33420339/1056954
extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResourcesForAsset(self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.valueForKey("filename") as? String
        }
        
        return fname
    }
}