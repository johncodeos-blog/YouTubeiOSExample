//
//  XCDYouTubeKitViewController.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//
import UIKit
import AVKit
import XCDYouTubeKit_kbexdev

class XCDYouTubeKitViewController: UIViewController {
    
    @IBOutlet var playerViewContainer: UIView!
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoId = "YE7VzlLtp-4"
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId, completionHandler: { [self] video, error in
            if let video = video {
                AVPlayerViewControllerManager.shared.video = video
                let playerViewController = AVPlayerViewControllerManager.shared.controller
                playerViewController.allowsPictureInPicturePlayback = false
                playerViewController.view.frame = playerViewContainer.bounds
                addChild(playerViewController)
                if let view = playerViewController.view {
                    playerViewContainer.addSubview(view)
                }
                playerViewController.didMove(toParent: self)

            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AVPlayerViewControllerManager.shared.controller.player?.pause()
    }
}
