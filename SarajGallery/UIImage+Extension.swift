//
//  UIImage+Extension.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit

import Accelerate

extension UIImage
{
    // MARK: Hisogram Functions
    
    //Stackoverflow
    func SIHistogramCalculation() -> (alpha: [UInt], red: [UInt], green: [UInt], blue: [UInt])
    {
        let imageRef = self.CGImage
        
        let inProvider = CGImageGetDataProvider(imageRef)
        let inBitmapData = CGDataProviderCopyData(inProvider)
        
        var inBuffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: UInt(CGImageGetHeight(imageRef)), width: UInt(CGImageGetWidth(imageRef)), rowBytes: CGImageGetBytesPerRow(imageRef))
        
        let alpha = [UInt](count: 256, repeatedValue: 0)
        let red = [UInt](count: 256, repeatedValue: 0)
        let green = [UInt](count: 256, repeatedValue: 0)
        let blue = [UInt](count: 256, repeatedValue: 0)
        
        let alphaPtr = UnsafeMutablePointer<vImagePixelCount>(alpha)
        let redPtr = UnsafeMutablePointer<vImagePixelCount>(red)
        let greenPtr = UnsafeMutablePointer<vImagePixelCount>(green)
        let bluePtr = UnsafeMutablePointer<vImagePixelCount>(blue)
        
        let rgba = [alphaPtr, redPtr, greenPtr, bluePtr]
        
        let histogram = UnsafeMutablePointer<UnsafeMutablePointer<vImagePixelCount>>(rgba)
        
        _ = vImageHistogramCalculation_ARGB8888(&inBuffer, histogram, UInt32(kvImageNoFlags))
        
        return (alpha, red, green, blue)
    }
    
    func GrayScaleFilter3()->UIImage{
        let filter = CIFilter(name: "CIColorMatrix")
        let img = CoreImage.CIImage(CGImage: self.CGImage!)
        let r:CGFloat = 0.2125
        let g:CGFloat = 0.7154
        let b:CGFloat = 0.0721
        filter!.setDefaults()
        filter!.setValue(img, forKey: "inputImage")
        filter!.setDefaults()
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputRVector")
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputGVector")
        filter!.setValue(CIVector(x:r, y:g, z:b, w:0), forKey:"inputBVector")
        let context = CIContext(options:nil)
        let cgimg = context.createCGImage(filter!.outputImage!, fromRect: filter!.outputImage!.extent)
        return UIImage(CGImage: cgimg)
    }
    
    func GrayScaleFilter2() -> UIImage {
        let img = CoreImage.CIImage(CGImage: self.CGImage!)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setDefaults()
        filter!.setValue(img, forKey: "inputImage")
        filter!.setValue(0, forKey: "inputSaturation")
        let context = CIContext(options:nil)
        let cgimg = context.createCGImage(filter!.outputImage!, fromRect: filter!.outputImage!.extent)
        return UIImage(CGImage: cgimg)
    }
    
    func GrayScaleFilter() -> UIImage {
        
        let imageRect = CGRectMake(0,0,CGFloat(CGImageGetWidth(self.CGImage)),CGFloat(CGImageGetHeight(self.CGImage)))
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGBitmapContextCreate(nil, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage), 8, 0, colorSpace, CGBitmapInfo.ByteOrderDefault.rawValue)
        CGContextDrawImage(context, imageRect, self.CGImage)
        let imageRef = CGBitmapContextCreateImage(context)
        let newImage = UIImage(CGImage: imageRef!, scale: CGFloat(CGImageGetWidth(self.CGImage))/self.size.width, orientation: UIImageOrientation.Up)
        
        return newImage
    }

    func NegativeFilter() -> UIImage? {
        
        let img = CoreImage.CIImage(CGImage: self.CGImage!)
        
        let filter = CIFilter(name: "CIColorInvert")
        filter!.setDefaults()
        
        filter!.setValue(img, forKey: "inputImage")
        
        let context = CIContext(options:nil)
        
        let cgimg = context.createCGImage(filter!.outputImage!, fromRect: filter!.outputImage!.extent)
        
        return UIImage(CGImage: cgimg)
    }
}