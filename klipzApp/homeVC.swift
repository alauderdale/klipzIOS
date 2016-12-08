//
//  homeVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/27/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse



class homeVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color
        collectionView?.backgroundColor = UIColor.white
        
        //title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        header.usernameLbl.text = PFUser.current()?.object(forKey: "username") as? String
        
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.button.setTitle("edit profile", for: UIControlState.normal)
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        
        avaQuery.getDataInBackground {(data:Data? , Error:Error?) -> Void in
            
            header.avatarImg.image = UIImage(data:data!)
            
        }
        
        return header
    }
    
    
    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        return cell
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
