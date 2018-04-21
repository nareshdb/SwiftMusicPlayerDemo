//
//  SignUpViewController.swift
//  Rodeo
//
//  Created by Admin on 15/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//


import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController
{
    //MARK: ----------------OUTLETS--------------------
    
    @IBOutlet var viewFullName: UIView!
    @IBOutlet var viewUserName: UIView!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var txtFullName: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var iconFullName: UIImageView!
    @IBOutlet var iconUserName: UIImageView!
    @IBOutlet var iconEmail: UIImageView!
    @IBOutlet var iconPassword: UIImageView!
    @IBOutlet var lblTopLabel: UILabel!
    @IBOutlet var btnTermsOfServicesAndPrivacyPolicy: UIButton!
    @IBOutlet var lblByCreatingAnAccount: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewFullName.layer.cornerRadius = 2
        self.viewUserName.layer.cornerRadius = 2
        self.viewEmail.layer.cornerRadius = 2
        self.viewPassword.layer.cornerRadius = 2
        self.btnJoin.layer.cornerRadius = 2
        self.viewFullName.layer.borderWidth = 0.5
        self.viewFullName.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
        self.viewUserName.layer.borderWidth = 0.5
        self.viewUserName.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
        self.viewEmail.layer.borderWidth = 0.5
        self.viewEmail.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
        self.viewPassword.layer.borderWidth = 0.5
        self.viewPassword.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func btnJoinAction(_ sender: UIButton)
    {
        btnJoin.isUserInteractionEnabled = false
        // Delay 1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            self.btnJoin.isUserInteractionEnabled = true
        }
        self.view.endEditing(true)
        
        if validation()
        {
            appInstance.showLoader()
            Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!, completion: { (user, error) in
                appInstance.hideLoader()
                
                if error == nil {
                    appInstance.window!.makeToast("Please verify your email to proceed")
                    user?.sendEmailVerification(completion: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.view.makeToast(error?.localizedDescription)
                }
            })
        }
    }
    
    // Tap Gesture Action
    @IBAction func gestureTappedOnSuperView(_ sender: Any)
    {
        self.view.endEditing(true);
    }
}

//MARK: -----Extension-----
extension SignUpViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtFullName
        {
            iconFullName.image = UIImage(named: "ic_FullnameSelectedIcon")
            
        }
        if textField == txtUserName
        {
            iconUserName.image = UIImage(named: "ic_FullnameSelectedIcon")
        }
        if textField == txtEmail
        {
            iconEmail.image = UIImage(named: "ic_EmailSelectedIcon")
            
        }
        if textField == txtPassword
        {
            iconPassword.image = UIImage(named: "ic_PasswordSelectedIcon")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtFullName
        {
            iconFullName.image = UIImage(named: "ic_FullnameUnSelectedIcon")
            
        }
        if textField == txtUserName
        {
            iconUserName.image = UIImage(named: "ic_FullnameUnSelectedIcon")
        }
        if textField == txtEmail
        {
            iconEmail.image = UIImage(named: "ic_EmailUnSelectedIcon")
            
        }
        if textField == txtPassword
        {
            iconPassword.image = UIImage(named: "ic_PasswordUnSelectedIcon")
        }
        
    }
    
    
    // Validation
    
    func validation() -> Bool
    {
        txtUserName.text = txtUserName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        txtEmail.text = txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        txtFullName.text = txtFullName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        txtPassword.text = txtPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        

        if(txtFullName.text == "")
        {
            self.view.makeToast("Please enter Full name")
            txtFullName.becomeFirstResponder()
            return false
        }
        if(txtUserName.text == "")
        {
            self.view.makeToast("Please enter Username")
            txtUserName.becomeFirstResponder()
            return false
        }
        if(txtEmail.text == "")
        {
            self.view.makeToast("Please enter Email address")
            txtEmail.becomeFirstResponder()
            return false
        }

        if(txtPassword.text == "")
        {
            self.view.makeToast("Please enter Password")
            txtPassword.becomeFirstResponder()
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFullName
        {
            txtUserName.becomeFirstResponder()
        }
        else if textField == txtUserName
        {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail
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
