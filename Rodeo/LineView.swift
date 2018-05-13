//
//  LineView.swift
//  MusicPlayerTransition
//
//  Created by xxxAIRINxxx on 2015/08/31.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class LineView: UIView {

    @IBOutlet var imgCover: UIImageView!
    @IBOutlet var lblSongTitle: UILabel!
    @IBOutlet var btnPausePlay: UIButton!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    
    override func draw(_ rect: CGRect) {
        let topLine = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.5))
        UIColor.gray.setStroke()
        topLine.lineWidth = 0.2
        topLine.stroke()
        
        let bottomLine = UIBezierPath(rect: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        UIColor.lightGray.setStroke()
        bottomLine.lineWidth = 0.2
        bottomLine.stroke()
        
    }
    
    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
        switch MusicPlayerViewController.sharedPlayer.player.state {
        case .buffering:
            self.btnPausePlay.isHidden = true
            self.activityIndicator.isHidden = false
        case .failed(let error):
            appInstance.window?.makeToast(error.localizedDescription)
        case .paused:
            self.btnPausePlay.isHidden = false
            self.activityIndicator.isHidden = true
            self.btnPausePlay.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        case .playing:
            self.btnPausePlay.isHidden = false
            self.activityIndicator.isHidden = true
            self.btnPausePlay.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        case .stopped:
            self.btnPausePlay.isHidden = false
            self.activityIndicator.isHidden = true
            self.btnPausePlay.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        case .waitingForConnection:
            self.btnPausePlay.isHidden = true
            self.activityIndicator.isHidden = false
            self.btnPausePlay.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        }
    }
    
    @IBAction func btnplaypauseAction(_ sender: Any) {
        switch MusicPlayerViewController.sharedPlayer.player.state {
        case .buffering:
            break
        case .failed(let error):
            appInstance.window!.makeToast(error.localizedDescription)
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
}
