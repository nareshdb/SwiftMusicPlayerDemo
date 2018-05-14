//
//  SettingsViewController.swift
//  Rodeo
//
//  Created by Admin on 17/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblSettings: UITableView!
    @IBOutlet var musicView: UIView!
    
    var settings: [Setting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings = [
           /* Setting(name: "Profile", detail: "See you account details", icon: #imageLiteral(resourceName: "user"), action: {
                
            }),
            Setting(name: "Subscription", detail: "Your subscription details", icon: #imageLiteral(resourceName: "subscribe-rss-button"), action: {
                
            }),
            Setting(name: "Family Share", detail: "Share your subcription with your family", icon: #imageLiteral(resourceName: "family-silhouette"), action: {
                
            }),*/
            Setting(name: "Logout", detail: "", icon: #imageLiteral(resourceName: "frown"), action: {
                let alert = UIAlertController.init(title: "Confirm", message: "Are you sure you want to Logout?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.default, handler: { (test) in
                    MusicPlayerViewController.sharedPlayer.player.stop()
                    do {
                        try Auth.auth().signOut()
                        if let vc = self.navigationController?.viewControllers.first(where: {$0 is SignInViewController}) {
                            _ = self.navigationController?.popToViewController(vc, animated: true)
                            
                        }
                        else {
                            let loginVC = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                    }
                    catch _ {
                        
                        let loginVC = UIStoryboard.init(name: "Authentication", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }))
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            })
        ]
        self.tblSettings.reloadData()
        self.tblSettings.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.selectionStyle = .none
        cell.detailTextLabel?.text = self.settings[indexPath.row].detail
        
        cell.textLabel?.text = self.settings[indexPath.row].name
        cell.imageView?.image = self.settings[indexPath.row].icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.settings[indexPath.row].action()
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        self.present(MusicPlayerViewController.sharedPlayer, animated: true, completion: nil)
    }
}

class Setting: NSObject {
    
    var name: String = ""
    var action: ()->() = {}
    var detail: String = ""
    var icon: UIImage!
    
    convenience init(name: String, detail: String, icon: UIImage, action: @escaping ()->()) {
        self.init()
        self.action = action
        self.name = name
        self.icon = icon
        self.detail = detail
    }
}
