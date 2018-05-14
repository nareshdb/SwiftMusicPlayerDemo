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
import Toast_Swift

var favSongs: [String:Bool] {
    get {
        return UserDefaults.standard.value(forKey: "favSongs") as? [String:Bool] ?? [:]
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "favSongs")
        UserDefaults.standard.synchronize()
    }
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblSongs: UITableView!
    @IBOutlet var musicView: UIView!
    @IBOutlet var isSubscribedView: UIView!
    @IBOutlet var btnFav: UIButton!
    
    var songs: [Music] = []
    var currentlyPlaying: Music!
    var blurView: DynamicBlurView!
    var shouldShowFav: Bool = false
    var finalSongs: [Music] {
        if shouldShowFav {
            return self.songs.flatMap{favSongs[$0.key] ?? false ? $0 : nil}
        }
        return self.songs
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblSongs.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        self.blurView = DynamicBlurView.init(frame: self.view.bounds)
        self.blurView.blurRadius = 5
        self.checkSubscription()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkSubscription), name: NSNotification.Name.init("subscribed"), object: nil)
        
        ToastManager.shared.position = .top
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
            MusicPlayerViewController.sharedPlayer.playList = self.songs
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MusicTableViewCell
        let music = self.finalSongs[indexPath.row]
        cell.imgLabel.kf.indicatorType = .activity
        cell.imgLabel.kf.setImage(with: music.coverImage, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.btnFav.setImage((favSongs[music.key] ?? false) ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav"), for: .normal)
        cell.lblSongName.text = music.name
        cell.lblArtistName.text = music.artistName
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerViewController.sharedPlayer.currentMusicItem = self.finalSongs[indexPath.row]
        MusicPlayerViewController.sharedPlayer.playList = self.finalSongs
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        self.present(MusicPlayerViewController.sharedPlayer, animated: true, completion: nil)
    }
    
    @IBAction func btnFavAction(_ sender: Any) {
        self.shouldShowFav = !self.shouldShowFav
        self.btnFav.setImage(self.shouldShowFav ? #imageLiteral(resourceName: "fav") : #imageLiteral(resourceName: "unfav") , for: .normal)
        self.view.makeToast(self.shouldShowFav ? "Only favorites" : "All songs")
        self.tblSongs.reloadData()
    }
    
    @IBAction func btnSubscribedTapped(_ sender: UIButton) {
        playerView?.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: MusicCellDelegate {
    func didSelectFav(cell: MusicTableViewCell) {
        if let index = self.tblSongs.indexPath(for: cell) {
            if favSongs[self.finalSongs[index.row].key] ?? false {
                favSongs[self.finalSongs[index.row].key] = false
                self.view.makeToast("Removed from favorites")
            }
            else {
                favSongs[self.finalSongs[index.row].key] = true
                self.view.makeToast("Added to favorites")
            }
        }
        self.tblSongs.reloadData()
    }
}
