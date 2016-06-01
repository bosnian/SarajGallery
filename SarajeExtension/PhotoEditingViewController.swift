//
//  PhotoEditingViewController.swift
//  SarajeExtension
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {

    var input: PHContentEditingInput?
    
    var filter: CIFilter = CIFilter()
    let formatIdentifier = "com.ammar.SarajGallery"
    let formatVersion    = "1.0"
    var isFilterAdded = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filter.setDefaults()
    }

    @IBAction func negativePressed(sender: AnyObject) {
        self.filter = CIFilter.Negative()
        refreshImageView()
    }
    
    @IBAction func grayscalePressed(sender: AnyObject) {
        self.filter = CIFilter.GrayScale()
        refreshImageView()
    }
    
    func refreshImageView(){
        isFilterAdded = true
        if( input != nil && input?.displaySizeImage != nil){
            self.imageView.image = self.filter.getImageFromFilterUIImage(input!.displaySizeImage!)
        }
    }

    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        return adjustmentData?.formatIdentifier == formatIdentifier &&
            adjustmentData?.formatVersion == formatVersion
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
    
        input = contentEditingInput
        if let input = contentEditingInput {
            imageView.image = input.displaySizeImage
        }
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            
            if self.input == nil {
                return
            }
            
            let output = PHContentEditingOutput(contentEditingInput: self.input!)
            
            if self.isFilterAdded == false {
                completionHandler?(output)
                return
            }
            
            let archivedData = NSKeyedArchiver.archivedDataWithRootObject("Filter")
            let newAdjustmentData = PHAdjustmentData(formatIdentifier: self.formatIdentifier,
                                                     formatVersion: self.formatVersion,
                                                     data: archivedData)
            output.adjustmentData = newAdjustmentData
            
            let fullSizeImage = CIImage(contentsOfURL: self.input!.fullSizeImageURL!)
            UIGraphicsBeginImageContext(fullSizeImage!.extent.size);
            UIImage(CIImage: self.filter.getImageFromFilterCIImage(fullSizeImage!)).drawInRect(fullSizeImage!.extent)
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            let jpegData = UIImageJPEGRepresentation(outputImage, 1.0)
            UIGraphicsEndImageContext()
            jpegData!.writeToURL(output.renderedContentURL, atomically: true)
            
            completionHandler?(output)
        }
    }

    var shouldShowCancelConfirmation: Bool {
        return true
    }

    func cancelContentEditing() {
        if let input = input {
            imageView.image = input.displaySizeImage
        }
    }
}
