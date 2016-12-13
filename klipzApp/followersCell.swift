//
//  followersCell.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 12/8/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()

        // alignment
        let width = UIScreen.main.bounds.width
        
        avatarImg.frame = CGRect(x: 10, y: 10, width: width / 5.3, height: width / 5.3)
        usernameLbl.frame = CGRect(x: avatarImg.frame.size.width + 20, y: 28, width: width / 3.2, height: 30)
        followBtn.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        // round ava
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
        avatarImg.clipsToBounds = true
        
    }
    
    // clicked follow / unfollow
    @IBAction func followBtn_click(_ sender: Any) {
        
        let title = followBtn.title(for: UIControlState())
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success:Bool, error:Error?) -> Void in
                if success {
                    self.followBtn.setTitle("FOLLOWING", for: UIControlState())
                    self.followBtn.backgroundColor = .green
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success:Bool, error:Error?) -> Void in
                            if success {
                                self.followBtn.setTitle("FOLLOW", for: UIControlState())
                                self.followBtn.backgroundColor = .lightGray
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
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
