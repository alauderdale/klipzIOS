//
//  signUpVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/26/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    //reset default size
    var scrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    //profile image
    @IBOutlet weak var avatarImg: UIImageView!
    
    //textfield
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    //button
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // scrollview frame size
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        
        //check notifications if keyboard is shown or not
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(signUpVC.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(signUpVC.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round avatar
        avatarImg.layer.cornerRadius = avatarImg.frame.width / 2
        avatarImg.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avatarImg.userInteractionEnabled = true
        avatarImg.addGestureRecognizer(avaTap)
        
        //alignment
        avatarImg.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 40, 80, 80)
        usernameTxt.frame = CGRectMake(10, avatarImg.frame.origin.y + 90, self.view.frame.size.width - 20, 30)
        emailTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, emailTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        signUpBtn.frame = CGRectMake(20, passwordTxt.frame.origin.y + 60, self.view.frame.size.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20 , signUpBtn.frame.origin.y, self.view.frame.size.width / 4, 30)

    }
    
    //call picker to select image
    func loadImg(recognizer: UITapGestureRecognizer){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    
    }
    
    //connect selected image to image view
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatarImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //hidekayboard if tapped
    func hideKeyboardTap(recogmizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    
    }
    
    //show keyboard
    func showKeyboard(notification:NSNotification){
        
        //define keyboard size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        
        //move up UI
        UIView.animateWithDuration(0.4) {() -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    //hide kayboard func
    func hideKeyboard(notification:NSNotification){
        
        //move down UI
        UIView.animateWithDuration(0.4) {() -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    

    //clicked sign up
    @IBAction func signUpBtn_click(sender: AnyObject) {
        print("sign up pressed")
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        
        //if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty ){
        
            //alert message
            let alert = UIAlertController(title: "Opps!", message: "Please fill all required fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "Rock on!", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        //send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text

        
        //will be assigned in edit profile
        user["gender"] = ""
        user["bio"] = ""

        
        //convert our image for sending to server
        let avaData = UIImageJPEGRepresentation(avatarImg.image!, 0.5)
        let avaFile = PFFile(name: "avatar.jpg", data: avaData!)
        user["ava"] = avaFile
        
        //save data to server
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success{
                print("registered")
                
                //remember if user is logged in 
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //call login func from AppDelegate.swift class 
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                //show alert message
                let alert = UIAlertController(title: "Opps!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "Understood", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    //clicked cancel
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        //hide keyboard when pressing cancel
        self.view.endEditing(true)
        
        print("cancel pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    



}
