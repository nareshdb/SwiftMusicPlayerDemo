//
//  MusicPlayerViewController.swift
//  Rodeo
//
//  Created by Admin on 20/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit
import KDEAudioPlayer

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet weak var blurBgImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ipv: InteractivePlayerView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playPauseButtonView: UIView!
    
    static var sharedPlayer: MusicPlayerViewController = {
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        _ = vc.view
        return vc
    }()
    
    var player = AudioPlayer.init()
    
    var currentMusicItem: Music? = nil {
        didSet {
            if self.isViewLoaded {
                // duration of music
                self.ipv.progress = 50.0
                self.ipv.stop()
                self.player.stop()
                let item = AudioItem.init(highQualitySoundURL: nil, mediumQualitySoundURL: self.currentMusicItem?.songURL!, lowQualitySoundURL: nil)
                self.player.play(item: item!)
                playerView?.imgCover.kf.setImage(with: self.currentMusicItem?.coverImage)
                playerView?.lblSongTitle.text = self.currentMusicItem?.name
            }
        }
    }
    
    var playList: [Music]? = nil {
        didSet {
            if self.playList == nil {
                return
            }
            for p in self.playList! {
                if self.currentMusicItem == nil {
                    self.currentMusicItem = p
                    self.player.add(item: AudioItem(highQualitySoundURL: nil, mediumQualitySoundURL: p.songURL!, lowQualitySoundURL: nil)!)
                }
                else {
                    self.player.add(item: AudioItem(highQualitySoundURL: nil, mediumQualitySoundURL: p.songURL!, lowQualitySoundURL: nil)!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.clear
        self.makeItRounded(view: self.playPauseButtonView, newSize: self.playPauseButtonView.frame.width)
        self.ipv!.delegate = self
        
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.ipv.start()
        self.player.play(item: self.player.currentItem!)
        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        self.ipv.stop()
        self.player.pause()
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 50)
        self.player.next()
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 10)
        self.player.previous()
    }
    
    @IBAction func btnDismiss(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRect(x: view.frame.origin.x,y: view.frame.origin.y,width: newSize,height : newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
    }
}

extension MusicPlayerViewController: InteractivePlayerViewDelegate {
    
    func actionOneButtonTapped(sender: UIButton, isSelected: Bool) {
        print("shuffle \(isSelected.description)")
    }
    
    func actionTwoButtonTapped(sender: UIButton, isSelected: Bool) {
        print("like \(isSelected.description)")
    }
    
    func actionThreeButtonTapped(sender: UIButton, isSelected: Bool) {
        print("replay \(isSelected.description)")
        
    }
    
    func interactivePlayerViewDidChangedDuration(playerInteractive: InteractivePlayerView, currentDuration: Double) {
        print("current Duration : \(currentDuration)")
    }
    
    func interactivePlayerViewDidStartPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did started")
    }
    
    func interactivePlayerViewDidStopPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did stop")
    }
}

extension MusicPlayerViewController: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
    }
    
}

