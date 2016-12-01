//
//  resetPasswordVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/26/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    //textfields
    @IBOutlet weak var emailTxt: UITextField!
    
    //buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //alignment
        emailTxt.frame = CGRectMake(10, 120, self.view.frame.size.width - 20, 30 )
        resetBtn.frame = CGRectMake(20, emailTxt.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20 , resetBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
    }
    
    //clicked reset button
    @IBAction func resetBtn_click(sender: AnyObject) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        
        //email text field is empty
        if emailTxt.text!.isEmpty{
        
            //show alert message
            let alert = UIAlertController(title: "Opps", message: "Email is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        //request for resetting  password
        PFUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (success:Bool, error:NSError?)-> Void in
            if success{
           
                //show alert message
                let alert = UIAlertController(title: "Check you email", message: "password reset sent", preferredStyle: UIAlertControllerStyle.Alert)
                
                //if pressed OK call self.dismiss function
                let ok = UIAlertAction(title: "Thanks", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
                
            
            } else{
                print(error?.localizedDescription)
            }
            
            
        }
        
    }
    
    //clicked cancel button
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        //hide keyboard when pressing cancel
        self.view.endEditing(true)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    






}
