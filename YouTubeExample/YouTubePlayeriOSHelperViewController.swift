//
//  YouTubePlayeriOSHelperViewController.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import YouTubeiOSPlayerHelper

class YouTubePlayeriOSHelperViewController: UIViewController {
    
    @IBOutlet var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        loadVideo(videoId: "YE7VzlLtp-4")
    }
    
    private func setupPlayerView() {
        playerView.delegate = self
        playerView.webView?.backgroundColor = .black
        playerView.webView?.isOpaque = false
    }
    
    private func loadVideo(videoId: String) {
        // Set playsinline = 1 to enable the video play inside the UIViewController
        let playerVars: [String: Any] = ["playsinline": 1]
        playerView.load(withVideoId: videoId, playerVars: playerVars)
    }
    
    // Uncomment the following method if you want to change the video after you loaded the first one
    /*
    private func loadAnotherVideo(videoId: String, startSeconds: Float) {
        playerView.cueVideo(byId: videoId, startSeconds: startSeconds)
    }
    */
}

extension YouTubePlayeriOSHelperViewController: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
    
    // Uncomment the following method if you want to use a custom loading view
    /*
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let customLoadingView = UIView()
        // Create a custom loading view
        return customLoadingView
    }
    */
}

