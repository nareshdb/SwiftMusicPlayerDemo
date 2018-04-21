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
        
        Database.database().reference().child(Auth.auth().currentUser!.uid).child("my_songs").observe(.childAdded, with: { (snap) in
            let music = Music(snapshot: snap)
            self.songs.append(music)
            self.tblSongs.reloadData()
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    @IBAction func musicTapped(_ sender: UIButton) {
        self.present(MusicPlayerViewController.sharedPlayer, animated: true, completion: nil)
    }
}
