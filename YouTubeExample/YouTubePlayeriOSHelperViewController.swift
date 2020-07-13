//
//  YouTubePlayeriOSHelperViewController.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubePlayeriOSHelperViewController: UIViewController {
    @IBOutlet var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set playsinline = 1 to able to play the video inside the UIViewController
        playerView.delegate = self
        playerView.load(withVideoId: "YE7VzlLtp-4", playerVars: ["playsinline": "1"])
        
        // If you want to change the video after you loaded the first one, use the following code
//        playerView.cueVideo(byId: "DQuhA5ZCV9M", startSeconds: 0)
        
        playerView.webView?.backgroundColor = .black
        playerView.webView?.isOpaque = false
    }
}

extension YouTubePlayeriOSHelperViewController: YTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
    
//    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
//        let customLoadingView = UIView()
//        Create a custom loading view
//        return customLoadingView
//    }
}
