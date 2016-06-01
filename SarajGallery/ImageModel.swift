//
//  ImageModel.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Photos

class ImageModel {
    var img: UIImage?
    var title: String = ""
    var asset: PHAsset?
    var isHighRes = false
    
    init(img: UIImage, title: String?, asset: PHAsset){
        self.img = img
        self.title = title!
        self.asset = asset
    }
}
