//
//  AppDelegate.swift
//  YouTubeExample
//
//  Created by John Codeos on 06/01/2020.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AVPlayerViewControllerManager.shared.disconnectPlayer()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AVPlayerViewControllerManager.shared.reconnectPlayer(rootViewController: (window?.rootViewController)!)
    }

}
