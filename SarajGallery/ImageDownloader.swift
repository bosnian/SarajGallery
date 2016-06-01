//
//  ImageDownloader.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Async

class ImageDownloader {
    
    class func downloadImage(urlInput: String, success:(UIImage)->(), fail: ()->()){
    
        let defaultSession = NSURLSession.sharedSession()
        
        if let url = NSURL(string: urlInput) {
            let downloadPhotoTask: NSURLSessionDownloadTask = defaultSession.downloadTaskWithURL(
                url,
                completionHandler: {
                    (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
                    
                    Async.main {
                        if error == nil {
                            if let image = UIImage(data: NSData(contentsOfURL: location!)!){
                                success(image)
                            } else {
                                fail()
                            }
                        } else {
                            fail()
                        }
                    }
            })
            downloadPhotoTask.resume()
        } else {
            fail()
        }
    }
    
    class func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    class func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    class func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    class func getRandomPNGName()->String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(date) + ".png"
    }
    
    class func validateUrl(urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluateWithObject(urlString)
    }
}
