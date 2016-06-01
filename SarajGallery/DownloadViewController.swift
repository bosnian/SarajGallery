//
//  DownloadViewController.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closeView))
    }
    
    @IBAction func downloadImageFromUrl(sender: AnyObject) {
        
        if ImageDownloader.validateUrl(urlInput.text) {
            ImageDownloader.downloadImage(urlInput.text!, success: gotImage, fail: failedToDownload)
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid url", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func gotImage(img: UIImage){
        self.imageView.image = img
        
        ImageDownloader.saveImage(img, path: ImageDownloader.getRandomPNGName())
        let alert = UIAlertController(title: "Info", message: "Images saved", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func failedToDownload(){
        let alert = UIAlertController(title: "Error", message: "Could not downliad", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func closeView(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
        
    
}
