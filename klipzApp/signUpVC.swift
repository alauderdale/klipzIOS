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
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        
        //check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round avatar
        avatarImg.layer.cornerRadius = avatarImg.frame.width / 2
        avatarImg.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avatarImg.isUserInteractionEnabled = true
        avatarImg.addGestureRecognizer(avaTap)
        
        //alignment
        avatarImg.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 40, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avatarImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        signUpBtn.frame = CGRect(x: 20, y: passwordTxt.frame.origin.y + 60, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20 , y: signUpBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)

    }
    
    //call picker to select image
    func loadImg(_ recognizer: UITapGestureRecognizer){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    
    }
    
    //connect selected image to image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //hidekayboard if tapped
    func hideKeyboardTap(_ recogmizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    
    }
    
    //show keyboard
    func showKeyboard(_ notification:Notification){
        
        //define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        
        //move up UI
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }) 
    }
    
    //hide kayboard func
    func hideKeyboard(_ notification:Notification){
        
        //move down UI
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }) 
    }
    
    

    //clicked sign up
    @IBAction func signUpBtn_click(_ sender: AnyObject) {
        print("sign up pressed")
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        
        //if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty ){
        
            //alert message
            let alert = UIAlertController(title: "Opps!", message: "Please fill all required fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Rock on!", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text

        
        //will be assigned in edit profile
        user["gender"] = ""
        user["bio"] = ""

        
        //convert our image for sending to server
        let avaData = UIImageJPEGRepresentation(avatarImg.image!, 0.5)
        let avaFile = PFFile(name: "avatar.jpg", data: avaData!)
        user["ava"] = avaFile
        
        //save data to server
        user.signUpInBackground { (success:Bool, error:Error?) -> Void in
            if success{
                print("registered")
                
                //remember if user is logged in 
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                //call login func from AppDelegate.swift class 
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                //show alert message
                let alert = UIAlertController(title: "Opps!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Understood", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //clicked cancel
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        //hide keyboard when pressing cancel
        self.view.endEditing(true)
        
        print("cancel pressed")
        self.dismiss(animated: true, completion: nil)
    }

    



}
