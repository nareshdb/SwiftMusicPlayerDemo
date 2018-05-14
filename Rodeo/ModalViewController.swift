//
//  ModalViewController.swift
//  MusicPlayerTransition
//
//  Created by xxxAIRINxxx on 2015/02/25.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import RangeSeekSlider
import Kingfisher
import KDEAudioPlayer
import NVActivityIndicatorView

final class ModalViewController: UIViewController {
    
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var timeSlider: RangeSeekSlider!
    @IBOutlet weak var coverImage: UIImageView!
    var tapCloseButtonActionHandler : ((Void) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)
        self.view.sendSubview(toBack: blurView)
        self.indicatorView.startAnimating()
        self.timeSlider.delegate = self
        self.timeSlider.rightHandle.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleStateChange(notification:)), name: NSNotification.Name.init("playerstate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeCheck(notification:)), name: NSNotification.Name.init("time"), object: nil)
        
        
        switch MusicPlayerViewController.sharedPlayer.player.state {
        case .buffering:
            self.btnPlayPause.isHidden = true
            self.indicatorView.isHidden = false
        case .failed(let error):
            self.view.makeToast(error.localizedDescription)
        case .paused:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        case .playing:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        case .stopped:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        case .waitingForConnection:
            self.btnPlayPause.isHidden = true
            self.indicatorView.isHidden = false
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    @IBAction func tapCloseButton() {
        self.tapCloseButtonActionHandler?()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            self.coverImage.kf.setImage(with: MusicPlayerViewController.sharedPlayer.currentMusicItem?.coverImage)
        
            self.lblname.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.name
        
            self.lblArtist.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.artistName
        
        
        print("ModalViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ModalViewController viewWillDisappear")
    }
    
    @IBAction func btnForwardAction(_ sender: Any) {
        MusicPlayerViewController.sharedPlayer.next()
        
            self.coverImage.kf.setImage(with: MusicPlayerViewController.sharedPlayer.currentMusicItem?.coverImage)
        
        
            self.lblname.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.name
        
        
        
            self.lblArtist.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.artistName
        
    }
    
    @IBAction func btnbackwardAction(_ sender: Any) {
        MusicPlayerViewController.sharedPlayer.prev()
        
            self.coverImage.kf.setImage(with: MusicPlayerViewController.sharedPlayer.currentMusicItem?.coverImage)
        
            self.lblname.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.name
        
            self.lblArtist.text = MusicPlayerViewController.sharedPlayer.currentMusicItem?.artistName
        
    }
    
    @IBAction func btnplaypauseAction(_ sender: Any) {
        switch MusicPlayerViewController.sharedPlayer.player.state {
        case .buffering:
            break
        case .failed(let error):
            self.view.makeToast(error.localizedDescription)
        case .paused:
            MusicPlayerViewController.sharedPlayer.player.resume()
        case .playing:
            MusicPlayerViewController.sharedPlayer.player.pause()
        case .stopped:
            MusicPlayerViewController.sharedPlayer.player.resume()
        case .waitingForConnection:
            break
        }
    }
    
    func timeCheck(notification: Notification) {
        
    }
    
    func handleStateChange(notification: Notification) {
        let object = notification.object as! (from: AudioPlayerState, to: AudioPlayerState)
        switch object.to {
        case .buffering:
            self.btnPlayPause.isHidden = true
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
        case .failed(let error):
            self.view.makeToast(error.localizedDescription)
        case .paused:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.indicatorView.stopAnimating()
        case .playing:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.indicatorView.stopAnimating()
        case .stopped:
            self.btnPlayPause.isHidden = false
            self.indicatorView.isHidden = true
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.indicatorView.stopAnimating()
        case .waitingForConnection:
            self.btnPlayPause.isHidden = true
            self.indicatorView.isHidden = false
            self.btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.indicatorView.startAnimating()
        }
    }
}

extension ModalViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        
        if let seconds = MusicPlayerViewController.sharedPlayer.player.currentItemDuration {
            let time = secondsToHoursMinutesSeconds(seconds: Int(seconds))
            let hour = time.0 > 0 ? time.0.description + ":" : ""
            let minutes = time.1
            let seconds = ":" + time.2.description
            return hour + minutes.description + seconds.description
        }
        else {
            return "00:00"
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        return ""
    }
    
    
}


func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}
