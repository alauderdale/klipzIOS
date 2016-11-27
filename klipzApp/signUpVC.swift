//
//  signUpVC.swift
//  klipzApp
//
//  Created by Alex Lauderdale on 11/26/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    
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
    }
    
    //clicked cancel
    @IBAction func cancelBtn_click(sender: AnyObject) {
        print("cancel pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    



}
