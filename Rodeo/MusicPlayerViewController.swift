//
//  MusicPlayerViewController.swift
//  Rodeo
//
//  Created by Admin on 20/04/18.
//  Copyright © 2018 AstroWorld. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    
    @IBOutlet var musicPlayerView: InteractivePlayerView!
    @IBOutlet weak var blurBgImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ipv: InteractivePlayerView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playPauseButtonView: UIView!
    
    static var sharedPlayer: MusicPlayerViewController {
        let vc = UIStoryboard(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        _ = vc.view
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.clear
        self.makeItRounded(view: self.playPauseButtonView, newSize: self.playPauseButtonView.frame.width)
        
        self.ipv!.delegate = self
        
        // duration of music
        self.ipv.progress = 20.0
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.ipv.start()
        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        self.ipv.stop()
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
    }
    
    @IBAction func nextTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 50)
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
        self.ipv.restartWithProgress(duration: 10)
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
    
    
    
    /* InteractivePlayerViewDelegate METHODS */
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
