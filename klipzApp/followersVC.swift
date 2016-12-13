//
//  followersVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 12/8/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

var showMe = String()
var user = String()


class followersVC: UITableViewController {

    // arrays to hold data received from servers
    var usernameArray = [String]()
    var avaArray = [PFFile]()

    // array showing who do we follow or who followings us
    var followArray = [String]()

    // default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // title at the top
        self.navigationItem.title = showMe.uppercased()

        
        // load followers if tapped on followers label
        if showMe == "followers" {
            loadFollowers()
        }
        
        // load followings if tapped on followings label
        if showMe == "following" {
            loadFollowings()
        }
        

    }
    

    
    
    
    // loading followers
    func loadFollowers() {
        
        // STEP 1. Find in FOLLOW class people following User
        // find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground (block: { (objects:[PFObject]?, error:Error?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                // STEP 2. Hold received data
                // find related objects depending on query settings
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                
                // STEP 3. Find in USER class data of users following "User"
                // find users following user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        // find related objects in User class of Parse
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }

    
    
    
    // loading followings
    func loadFollowings() {
        
        // STEP 1. Find people followed by User
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground (block: { (objects:[PFObject]?, error:Error?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects! {
                    self.followArray.append(object.value(forKey: "following") as! String)
                }
                
                // STEP 3. Basing on followArray information (inside users) show infromation from User class of Parse
                // find users followeb by user
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        // find related objects in "User" class of Parse
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    

    
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }

    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        // STEP 1. Connect data from serv to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) -> Void in
            if error == nil {
                cell.avatarImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        // STEP 2. Show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackground (block: { (count:Int32, error:Error?) -> Void in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("FOLLOW", for: UIControlState())
                    cell.followBtn.backgroundColor = .lightGray
                } else {
                    cell.followBtn.setTitle("FOLLOWING", for: UIControlState())
                    cell.followBtn.backgroundColor = UIColor.green
                }
            }
        })
        
        
        // STEP 3. Hide follow button for current user
        if cell.usernameLbl.text == PFUser.current()?.username {
            cell.followBtn.isHidden = true
        }
        
        return cell
    }
    
    // selected some user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // recall cell to call further cell's data
        let cell = tableView.cellForRow(at: indexPath) as! followersCell
        
        // if user tapped on himself, go home, else go guest
        if cell.usernameLbl.text! == PFUser.current()!.username! {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    func back(_ sender : UITabBarItem) {
        self.navigationController?.popViewController(animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
