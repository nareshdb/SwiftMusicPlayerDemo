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
        self.selectedPlan = 0
    }

    @IBAction func btnSubscribe(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSelectMonth(_ sender: Any) {
        self.selectedPlan = 0
    }
    
    @IBAction func btnSelectYear(_ sender: Any) {
        self.selectedPlan = 1
    }

}
