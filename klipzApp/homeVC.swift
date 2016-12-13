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
    
    //refresher variable
    var refresher : UIRefreshControl!
    
    //size of page
    var page : Int = 10
    
    var uuidArray =  [String]()
    
    var picArray = [PFFile]()

    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        //background color
        collectionView?.backgroundColor = UIColor.white
        
        //title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        //pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        //load posts func
        loadPosts()
        
        
    }
    
    //refresh function
    func refresh () {
        
        //reload data information
        collectionView?.reloadData()
        
        //stop animating refresher
        refresher.endRefreshing()
    }
    
    //load posts function
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground { (opbects:[PFObject]?, error:Error?) -> Void in
            if error == nil {
                
                //cleanup
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                //find objects related to our query
                for object in opbects! {
                    
                    //add found data to arrays (holders)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    

    //cell number
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }

    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }
    
    
    //cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        //get picture from the picArray indexPath.row
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) -> Void in
            if error == nil {
               cell.picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        // STEP 1. get user data
        //get user's data with connections to PFuser class
        header.usernameLbl.text = PFUser.current()?.object(forKey: "username") as? String
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        
        header.bioLbl.sizeToFit()
        header.button.setTitle("edit profile", for: UIControlState.normal)
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground {(data:Data? , Error:Error?) -> Void in
            
            header.avatarImg.image = UIImage(data:data!)
            
        }

        
        //STEP 2. Count statitistics 
        //count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        followers.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }

        //count total followings
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: PFUser.current()!.username!)
        following.countObjectsInBackground { (count:Int32, error:Error?) -> Void in
            if error == nil {
                header.following.text = "\(count)"
            }
        }
        
        //STEP 3. Impliment tap gestures
        
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap following
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingTap))
        followersTap.numberOfTapsRequired = 1
        header.following.isUserInteractionEnabled = true
        header.following.addGestureRecognizer(followingTap)
        
        
        
        return header
    }
    
    //tapped posts label
    func postsTap(){
        
        if !picArray.isEmpty {
            
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
            
        }
    }
    

    
    
    
    // tapped followers label
    func followersTap() {
        
        user = PFUser.current()!.username!
        showMe = "followers"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped followings label
    func followingTap() {
        
        user = PFUser.current()!.username!
        showMe = "following"
        
        // make reference to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    //clicked log out
    @IBAction func logout(_ sender: Any) {
        
        // implement log out
        PFUser.logOutInBackground { (error:Error?) -> Void in
            if error == nil {
                
                // remove logged in user from App memory
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
                
            }
        }
        
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
