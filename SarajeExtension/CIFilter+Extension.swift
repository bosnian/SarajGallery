//
//  CIFilter+Extension.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit

extension CIFilter {
    
    func getImageFromFilterCIImage(img: CIImage) -> CIImage{
        self.setValue(img, forKey: "inputImage")
        let context = CIContext(options:nil)
        let cgimg = context.createCGImage(self.outputImage!, fromRect: self.outputImage!.extent)
        return CIImage(CGImage: cgimg)
    }
    
    func getImageFromFilterUIImage(img: UIImage) -> UIImage{
        let i = CIImage(image: img)
        return UIImage(CIImage: getImageFromFilterCIImage(i!))
    }
    
    class func GrayScale() -> CIFilter {
        let filter = CIFilter(name: "CIColorMatrix")
        filter!.setDefaults()
        let r:CGFloat = 0.2125
        let g:CGFloat = 0.7154
        let b:CGFloat = 0.0721
        filter!.setDefaults()
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputRVector")
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputGVector")
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputBVector")
        return filter!
    }
    
    class func Negative() -> CIFilter{
        let filter = CIFilter(name: "CIColorInvert")
        filter!.setDefaults()
        return filter!
    }
}
