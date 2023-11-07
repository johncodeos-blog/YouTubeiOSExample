//
//  WebViewViewController.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet weak var webPlayerView: UIView!
    
    lazy var webPlayer: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: webPlayerView.bounds, configuration: webConfiguration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebPlayer()
        loadVideoURL("https://www.youtube.com/embed/YE7VzlLtp-4?playsinline=1")
    }
    
    private func setupWebPlayer() {
        webPlayerView.addSubview(webPlayer)
        webPlayer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func loadVideoURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webPlayer.load(request)
    }
}
