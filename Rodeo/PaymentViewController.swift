//
//  PaymentViewController.swift
//  Rodeo
//
//  Created by Admin on 03/05/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe
import FirebaseAuth

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var btnPAY: UIButton!
    @IBOutlet weak var cardView: CreditCardFormView!
    let paymentTextField = STPPaymentCardTextField()

    var price: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.cardHolderString = Auth.auth().currentUser?.email ?? ""
        
        // Set up stripe textfield
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 0

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
        self.paymentTextField.becomeFirstResponder()
    }


    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationYear, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingCVC()
    }

    @IBAction func btnPay(_ sender: Any) {
        let alert = UIAlertController.init(title: nil, message: "You will be charged " + self.price, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) in
            let alert = UIAlertController.init(title: nil, message: "Thank you for subscribing.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) in
                appInstance.window!.rootViewController = nil
                UIView.transition(with: appInstance.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                    appInstance.window!.rootViewController = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeNVC")
                }, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
