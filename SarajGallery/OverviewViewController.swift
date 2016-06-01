//
//  OverviewViewController.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Photos


class OverviewViewController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    
    let imageManager = ImageManager()

    let reuseIdentifier = "ImageCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        
        ImageManager.authorize(authorized, unauthorized: unauthorized)
    }
    
    func prepareUI(){
        let cell = UINib(nibName: reuseIdentifier, bundle:nil)
        self.collView.registerNib(cell, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Image from URL", style: .Plain, target: self, action: #selector(showViewForImageDownload))
    }

    func authorized(){
        imageManager.loadAllImages {
            self.collView.reloadData()
        }
    }
    
    func unauthorized(){
        let alert = UIAlertController(title: "Error", message: "You must authorize app to use photos", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Authorize", style: UIAlertActionStyle.Cancel, handler: {
            action in
            ImageManager.authorize(self.authorized, unauthorized: self.unauthorized)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showViewForImageDownload(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DownloadNavigation")
        self.navigationController?.presentViewController(vc!, animated: true, completion: nil)
    }
}

