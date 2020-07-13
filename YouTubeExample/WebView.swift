//
//  WebView.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController {
    @IBOutlet var webPlayerView: UIView!
    
    var webPlayer: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add WebKit library in Build Phases > Link Binary With Libraries
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        DispatchQueue.main.async {
            self.webPlayer = WKWebView(frame: self.webPlayerView.bounds, configuration: webConfiguration)
            self.webPlayerView.addSubview(self.webPlayer)
            
            guard let videoURL = URL(string: "https://www.youtube.com/embed/YE7VzlLtp-4?playsinline=1") else { return }
            let request = URLRequest(url: videoURL)
            self.webPlayer.load(request)
        }
    }
}
