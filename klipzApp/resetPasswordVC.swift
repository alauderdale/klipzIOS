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
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30 )
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20 , y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
    }
    
    //clicked reset button
    @IBAction func resetBtn_click(_ sender: AnyObject) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        
        //email text field is empty
        if emailTxt.text!.isEmpty{
        
            //show alert message
            let alert = UIAlertController(title: "Opps", message: "Email is empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //request for resetting  password
        
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success:Bool, error:Error?)-> Void in
            if success{
           
                //show alert message
                let alert = UIAlertController(title: "Check you email", message: "password reset sent", preferredStyle: UIAlertControllerStyle.alert)
                
                //if pressed OK call self.dismiss function
                let ok = UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            
            } else{
                print(error!.localizedDescription)
            }
            
            
        }
        
    }
    
    //clicked cancel button
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        //hide keyboard when pressing cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    






}
