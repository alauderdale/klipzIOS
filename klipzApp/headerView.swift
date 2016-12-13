//
//  headerView.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/27/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

class headerView: UICollectionReusableView {
    
    //UI objects
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avatarImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        posts.frame = CGRect(x: width / 2.5, y: avatarImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.7, y: avatarImg.frame.origin.y, width: 50, height: 30)
        following.frame = CGRect(x: width / 1.25, y: avatarImg.frame.origin.y, width: 50, height: 30)
        
        postsTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingTitle.center = CGPoint(x: following.center.x, y: following.center.y + 20)
        
        button.frame = CGRect(x: postsTitle.frame.origin.x, y: postsTitle.center.y + 20, width: width - postsTitle.frame.origin.x - 10, height: 30)
        button.layer.cornerRadius = button.frame.size.width / 50
        
        usernameLbl.frame = CGRect(x: avatarImg.frame.origin.x, y: avatarImg.frame.origin.y + avatarImg.frame.size.height, width: width - 30, height: 30)
        
        bioLbl.frame = CGRect(x: avatarImg.frame.origin.x, y: usernameLbl.frame.origin.y + 30, width: width - 30, height: 30)
        
        // round ava
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
        avatarImg.clipsToBounds = true
    }
    
    //click following button
    @IBAction func followBtn_clicked(_ sender: Any) {
        
        let title = button.title(for: UIControlState())
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = guestname.last!
            object.saveInBackground(block: { (success:Bool, error:Error?) -> Void in
                if success {
                    self.button.setTitle("FOLLOWING", for: UIControlState())
                    self.button.backgroundColor = .green
                    
                    // send follow notification
                    let newsObj = PFObject(className: "news")
                    newsObj["by"] = PFUser.current()?.username
                    newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                    newsObj["to"] = guestname.last
                    newsObj["owner"] = ""
                    newsObj["uuid"] = ""
                    newsObj["type"] = "follow"
                    newsObj["checked"] = "no"
                    newsObj.saveEventually()
                    
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success:Bool, error:Error?) -> Void in
                            if success {
                                self.button.setTitle("FOLLOW", for: UIControlState())
                                self.button.backgroundColor = .lightGray
                                
                                
                                // delete follow notification
                                let newsQuery = PFQuery(className: "news")
                                newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                                newsQuery.whereKey("to", equalTo: guestname.last!)
                                newsQuery.whereKey("type", equalTo: "follow")
                                newsQuery.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
                                    if error == nil {
                                        for object in objects! {
                                            object.deleteEventually()
                                        }
                                    }
                                })
                                
                                
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }
        
        
    }
    
    
    
}
