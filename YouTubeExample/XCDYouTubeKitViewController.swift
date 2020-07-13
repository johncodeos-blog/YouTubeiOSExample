//
//  XCDYouTubeKitViewController.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//
import UIKit
import AVKit
import XCDYouTubeKit

class XCDYouTubeKitViewController: UIViewController {
    
    
    @IBOutlet var playerViewContainer: UIView!
    
    var playerView: AVPlayer!
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoId = "YE7VzlLtp-4"
        
        let youtubeClient = XCDYouTubeClient.default()
        youtubeClient.getVideoWithIdentifier(videoId) { video, _ in
            guard let ytVideo = video else { fatalError("Couldn't get the video from video id") }
            
            // YouTube has removed 1080p mp4 videos
            guard let streamURL = (ytVideo.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
                ytVideo.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ?? ytVideo.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? ytVideo.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]) else { fatalError("Couldn't get URL for this quality") }
            self.playerView = AVPlayer(url: streamURL)
            
            self.playerViewController.player = self.playerView
            self.addChild(self.playerViewController)
            
            // Add your view Frame
            self.playerViewController.view.frame = self.playerViewContainer.bounds
            
            // Add sub view in your view
            self.playerViewContainer.addSubview(self.playerViewController.view)
            
            // Start video when you open the ViewController
//            self.playerView.start()
            
            // Press play button to start the video
            self.playerView.pause()
        }
    }
}
