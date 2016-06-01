//
//  OverviewViewController+UICollectionViewDataSource.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit

extension OverviewViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageManager.getImageCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        let id = indexPath.row
        cell.imageView.image = imageManager.getImageAdIndex(id)?.img
        cell.title.text = imageManager.getImageAdIndex(id)?.title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80,height: 90)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        vc.imageManager = imageManager
        vc.id = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
