//
//  AVPlayerViewControllerManager.swift
//  XCDYouTubeKit iOS Demo
//
//  Created by Soneé John on 10/29/19.
//  Copyright © 2019 Cédric Luthi. All rights reserved.
//

import AVKit
import Foundation
import MediaPlayer
import XCDYouTubeKit_kbexdev

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

@objcMembers class AVPlayerViewControllerManager: NSObject {
    // MARK: - Public

    public static let shared = AVPlayerViewControllerManager()
    public var lowQualityMode = false
    public dynamic var duration: Float = 0
	
    public var video: XCDYouTubeVideo? {
        didSet {
            guard let video = video else { return }
            guard self.lowQualityMode == false else {
                guard let streamURL = video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? video.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? video.streamURLs[XCDYouTubeVideoQuality.small240.rawValue] else { fatalError("No stream URL") }
				
                self.player = AVPlayer(url: streamURL)
                self.controller.player = self.player
                return
            }
            let streamURL = video.streamURL
            self.player = AVPlayer(url: streamURL!)
            self.controller.player = self.player
        }
    }

    public var player: AVPlayer? {
        didSet {
            if let playerRateObserverToken = playerRateObserverToken {
                playerRateObserverToken.invalidate()
                self.playerRateObserverToken = nil
            }
			
            self.playerRateObserverToken = self.player?.observe(\.rate, changeHandler: { _, _ in
                self.updatePlaybackRateMetadata()
            })
            
            guard let video = self.video else { return }
            if let token = timeObserverToken {
                oldValue?.removeTimeObserver(token)
                self.timeObserverToken = nil
            }
            self.setupRemoteTransportControls()
            self.updateGeneralMetadata(video: video)
            self.updatePlaybackDuration()
        }
    }
	
    public lazy var controller: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        if #available(iOS 10.0, *) {
            controller.updatesNowPlayingInfoCenter = false
        }
        return controller
    }()
	
    override init() {
        super.init()
		
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance(), queue: .main) { notification in
			
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue)
            else {
                return
            }
			
            if type == .began {
                self.player?.pause()
            } else if type == .ended {
                guard (try? AVAudioSession.sharedInstance().setActive(true)) != nil else { return }
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                guard options.contains(.shouldResume) else { return }
                self.player?.play()
            }
        }
    }
	
    public func disconnectPlayer() {
        self.controller.player = nil
    }
	
    public func reconnectPlayer(rootViewController: UIViewController) {
        let viewController = rootViewController.topMostViewController()
        guard let playerViewController = viewController as? AVPlayerViewController else {
            if rootViewController is UINavigationController {
                guard let vc = (rootViewController as! UINavigationController).visibleViewController else { return }
                for childVC in vc.children {
                    guard let playerViewController = childVC as? AVPlayerViewController else { continue }
                    playerViewController.player = self.player
                    break
                }
            }
            return
        }
        playerViewController.player = self.player
    }
	
    // MARK: Private
	
    fileprivate var playerRateObserverToken: NSKeyValueObservation?
    fileprivate var timeObserverToken: Any?
    fileprivate let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    fileprivate func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.player?.rate == 0.0 {
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { _ in
            if self.player?.rate == 1.0 {
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    fileprivate func updateGeneralMetadata(video: XCDYouTubeVideo) {
        guard self.player?.currentItem != nil else {
            self.nowPlayingInfoCenter.nowPlayingInfo = nil
            return
        }
        
        var nowPlayingInfo = self.nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        let title = video.title
		
        if let thumbnailURL = video.thumbnailURLs {
            URLSession.shared.dataTask(with: thumbnailURL[0]) { data, _, error in
                guard error == nil else { return }
                guard data != nil else { return }
                guard let image = UIImage(data: data!) else { return }
				
                let artwork = MPMediaItemArtwork(image: image)
                nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            }.resume()
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
	
    fileprivate func updatePlaybackDuration() {
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
		
        timeObserverToken = self.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] _ in
            guard let player = self?.player else { return }
            guard player.currentItem != nil else { return }
			
            var nowPlayingInfo = self!.nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            self!.duration = Float(CMTimeGetSeconds(player.currentItem!.duration))
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self!.duration
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentItem!.currentTime())
            self!.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        })
    }
	
    fileprivate func updatePlaybackRateMetadata() {
        guard self.player?.currentItem != nil else {
            self.duration = 0
            self.nowPlayingInfoCenter.nowPlayingInfo = nil
            return
        }
        
        var nowPlayingInfo = self.nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player!.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = self.player!.rate
    }
}
