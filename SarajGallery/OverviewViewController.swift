//
//  OverviewViewController.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Photos
import Toast_Swift

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
        self.view.makeToast("Not authorized to access photos")
    }
    
    func showViewForImageDownload(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DownloadNavigation")
        self.navigationController?.presentViewController(vc!, animated: true, completion: nil)
    }
}

