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
            Setting(name: "Profile", detail: "See you account details", action: {
                
            }),
            Setting(name: "Subscription", detail: "Your subscription details", action: {
                
            }),
            Setting(name: "Family Share", detail: "Share your subcription with your family", action: {
                
            }),
            Setting(name: "Logout", detail: "", action: {
                
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
        cell.imageView?.image = #imageLiteral(resourceName: "ic_FullnameSelectedIcon")
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
    
    convenience init(name: String, detail: String, action: @escaping ()->()) {
        self.init()
        self.action = action
        self.name = name
    }
}
