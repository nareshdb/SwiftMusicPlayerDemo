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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblSongs: UITableView!
    @IBOutlet var musicView: UIView!
    @IBOutlet var isSubscribedView: UIView!
    
    var songs: [Music] = []
    var currentlyPlaying: Music!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDBObservers()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerViewController.sharedPlayer.currentMusicItem = self.songs[indexPath.row]
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        self.present(MusicPlayerViewController.sharedPlayer, animated: true, completion: nil)
    }
}
