//
//  HomeViewController.swift
//  Rodeo
//
//  Created by Admin on 16/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher
import DynamicBlurView

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblSongs: UITableView!
    @IBOutlet var musicView: UIView!
    @IBOutlet var isSubscribedView: UIView!
    
    var songs: [Music] = []
    var currentlyPlaying: Music!
    var blurView: DynamicBlurView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.blurView = DynamicBlurView.init(frame: self.view.bounds)
        self.blurView.blurRadius = 5
        self.checkSubscription()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkSubscription), name: NSNotification.Name.init("subscribed"), object: nil)
    }
    
    @objc
    func checkSubscription() {
        appInstance.showLoader()
        Database
            .database()
            .reference()
            .child("Users")
            .child(Auth.auth().currentUser!.uid)
            .child("subscriptionDeadline")
            .observe(.value, with: { (snap) in
                appInstance.hideLoader()
                if let time = snap.value as? TimeInterval,
                    time > Date().timeIntervalSince1970
                {
                    self.isSubscribedView.isHidden = true
                    self.addDBObservers()
                }
                else {
                    self.isSubscribedView.isHidden = false
                }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.blurView.frame = self.view.bounds
    }
    
    func addDBObservers() {
        
        Database.database().reference().child("songs").observe(.childAdded, with: { (snap) in
            let music = Music(snapshot: snap)
            self.songs.append(music)
            self.tblSongs.reloadData()
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MusicTableViewCell
        let music = self.songs[indexPath.row]
        cell.imgLabel.kf.indicatorType = .activity
        cell.imgLabel.kf.setImage(with: music.coverImage, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.lblSongName.text = music.name
        cell.lblArtistName.text = music.artistName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerViewController.sharedPlayer.currentMusicItem = self.songs[indexPath.row]
        MusicPlayerViewController.sharedPlayer.playList = self.songs
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        self.present(MusicPlayerViewController.sharedPlayer, animated: true, completion: nil)
    }
    
    @IBAction func btnSubscribedTapped(_ sender: UIButton) {
        playerView?.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
