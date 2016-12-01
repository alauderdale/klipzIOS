//
//  signInVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/26/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {
    
    //label
    
    @IBOutlet weak var label: UILabel!

    //textField
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    //buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()

        //font of label
        label.font = UIFont(name: "BrandonText-Bold", size: 35)
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //alignment
        label.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 50)
        usernameTxt.frame = CGRectMake(10, label.frame.origin.y + 70, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30 )
        forgotBtn.frame = CGRectMake(10, passwordTxt.frame.origin.y + 30, self.view.frame.size.width - 20, 30)
        signInBtn.frame = CGRectMake(20, forgotBtn.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        signUpBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20 , signInBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        
        //background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bg.image = UIImage(named: "bg@2x.png")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)

    }

    
    //hidekayboard if tapped
    func hideKeyboardTap(recogmizer:UITapGestureRecognizer){
        self.view.endEditing(true)
        
    }

    //click sign in button
    @IBAction func signInBtn_click(sender: AnyObject) {
        print("sign in pressed")
        
        //hide keyboard
        self.view.endEditing(true)
        
        //if text fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty{
            
            //show alert message
            let alert = UIAlertController(title: "Opps!", message: "Please fill all required fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "Rock on!", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            
        
        }
        
        //login functions
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:NSError?) in
            
            if error == nil {
                
                //remember user or save in app memory if user logged in
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            } else{
              
                //show alert message
                let alert = UIAlertController(title: "Opps!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "Understood", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
        }
    }


}
