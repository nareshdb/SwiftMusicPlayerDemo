//
//  ForgotPasswordViewController.swift
//  Rodeo
//
//  Created by Admin on 20/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    //MARK: -----------------------OUTLETS--------------------
    
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var iconEmail: UIImageView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblTopLabel: UILabel!
    @IBOutlet var lblMessage: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewEmail.layer.cornerRadius = 2
        self.viewEmail.layer.borderWidth = 0.5
        self.viewEmail.layer.borderColor = UIColor(colorLiteralRed: 201.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1).cgColor
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: --------------------ACTIONS----------------------
    
    @IBAction func btnSubmitForgotPassword(_ sender: UIButton)
    {
        btnSubmit.isUserInteractionEnabled = false
        // Delay 1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            self.btnSubmit.isUserInteractionEnabled = true
        }
        if(validation()){
            appInstance.showLoader()
            Auth.auth().sendPasswordReset(withEmail: self.txtEmail.text!, completion: { (error) in
                appInstance.hideLoader()
                if error == nil {
                    self.view.makeToast("Email sent successfully")
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.view.makeToast(error?.localizedDescription)
                }
            })
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gestureTapOnView(_ sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    //MARK: ---- Validation ----
    
    func validation() -> Bool
    {
        if(txtEmail.text! == "")
        {
            self.view.makeToast("Email is required")
            txtEmail.becomeFirstResponder()
            
            return false
        }
        if !self.txtEmail.text!.contains("@") {
            self.view.makeToast("Please enter a valid email address.")
            txtEmail.becomeFirstResponder()
            
            return false
        }
        return true
    }
}

//MARK: ---- Extension ----
extension ForgotPasswordViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtEmail
        {
            iconEmail.image = UIImage(named: "ic_EmailSelectedIcon")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtEmail
        {
            iconEmail.image = UIImage(named: "ic_EmailUnSelectedIcon")
        }
    }
    
}

