//
//  DownloadViewController.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 6/1/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Toast_Swift

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
            self.view.makeToast("Wrong url")
        }
    }
    
    func gotImage(img: UIImage){
        self.imageView.image = img
        
        ImageDownloader.saveImage(img, path: ImageDownloader.getRandomPNGName())
        self.view.makeToast("Image saved")
    }
    
    func failedToDownload(){
        self.view.makeToast("Could not download")
    }
    
    func closeView(){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
        
    
}
