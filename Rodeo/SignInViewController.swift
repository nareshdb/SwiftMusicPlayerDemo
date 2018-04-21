//
//  SignInViewController.swift
//  Rodeo
//
//  Created by Admin on 15/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//


import UIKit
import FirebaseAuth
import Swift
import Toast_Swift
import NVActivityIndicatorView

class SignInViewController: UIViewController
{
    //MARK: ------------------OUTLETS--------------------
    @IBOutlet var viewUsername: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var iconUsername: UIImageView!
    @IBOutlet var iconPassword: UIImageView!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var lblTopLabel: UILabel!
    
    //MARK: ----- Objects -----
    var mask: Bool = false // Preventing Multiple API Calls
    
    //MARK: ----- Methods -----
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewUsername.layer.cornerRadius = 2
        self.viewPassword.layer.cornerRadius = 2
        self.btnSignIn.layer.cornerRadius = 2
        self.viewUsername.layer.borderWidth = 0.5
        self.viewUsername.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
        self.viewPassword.layer.borderWidth = 0.5
        self.viewPassword.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ------------------ACTIONS--------------------
    
    @IBAction func btnSignIn(_ sender: UIButton)
    {
        btnSignIn.isUserInteractionEnabled = false
        // Delay 1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            self.btnSignIn.isUserInteractionEnabled = true
        }
        self.view.endEditing(true)
        if(validation())
        {
            
            appInstance.showLoader()
            
            Auth.auth().signIn(withEmail: txtUsername.text!, password: txtPassword.text!, completion: { (user, error) in
                appInstance.hideLoader()
                
                if error == nil {
                    if !(user?.isEmailVerified)! {
                        appInstance.window!.makeToast("Please verify email to proceed.")
                        user?.sendEmailVerification(completion: nil)
                        return
                    }
                    appInstance.window!.makeToast("Login Successfull")
                    let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeNVC")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.view.makeToast(error?.localizedDescription)
                }
                
            })
            
        }
    }
    
    @IBAction func ForgotPasswordBtnAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func gestureTapOnView(_ sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: ---- Validation ----
    func validation() -> Bool{
        
        btnSignIn.isUserInteractionEnabled = true
        if(txtUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            self.view.makeToast("Please enter Email")
            txtUsername.becomeFirstResponder()
            return false
            
        }
        
        if(txtPassword.text! == "")
        {
            
            self.view.makeToast("Please enter Password")
            txtPassword.becomeFirstResponder()
            return false
        }
        return true
    }
}

//MARK: ---- Extension ----
extension SignInViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtUsername
        {
            iconUsername.image = UIImage(named: "ic_FullnameSelectedIcon")
            
        }
        if textField == txtPassword
        {
            iconPassword.image = UIImage(named: "ic_PasswordSelectedIcon")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtUsername
        {
            iconUsername.image = UIImage(named: "ic_FullnameUnSelectedIcon")
        }
        if textField == txtPassword
        {
            iconPassword.image = UIImage(named: "ic_PasswordUnSelectedIcon")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtUsername
        {
            txtPassword.becomeFirstResponder()
        }
        else
        {
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
}
