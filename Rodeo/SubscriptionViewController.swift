//
//  SubscriptionViewController.swift
//  Rodeo
//
//  Created by Admin on 22/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var imgCart: UIImageView!
    @IBOutlet weak var imgCartYear: UIImageView!
    
    var selectedPlan = 0 {
        didSet {
            if !self.isViewLoaded {
                return
            }
            if self.selectedPlan == 0 {
                self.imgCart.isHidden = false
                self.imgCartYear.isHidden = true
            }
            else {
                self.imgCart.isHidden = true
                self.imgCartYear.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        self.selectedPlan = 0
    }

    @IBAction func btnSubscribe(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        vc.price = self.selectedPlan == 0 ? "₹ 39.99" : "₹ 199.99"
        let date = self.selectedPlan == 0 ? 60 * 60 * 24 * 30 : 60 * 60 * 24 * 30 * 12
        vc.finalDate = Double(date)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectMonth(_ sender: Any) {
        self.selectedPlan = 0
    }
    
    @IBAction func btnSelectYear(_ sender: Any) {
        self.selectedPlan = 1
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
