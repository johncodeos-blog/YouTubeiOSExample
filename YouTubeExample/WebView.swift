//
//  WebView.swift
//  YouTubeExample
//
//  Created by John Codeos on 6/1/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webPlayerView: UIView!
    
    // Use a lazy var to initialize the WKWebView only when it's needed.
    // This helps to reduce the initial load time of the view controller.
    lazy var webPlayer: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: webPlayerView.bounds, configuration: webConfiguration)

        webView.uiDelegate = self  // Set the UI delegate to handle any UI related tasks in the web view.
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebPlayer()
        loadVideoURL("https://www.youtube.com/embed/YE7VzlLtp-4?playsinline=1")
    }
    
    private func setupWebPlayer() {
        webPlayerView.addSubview(webPlayer)
        webPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webPlayer.topAnchor.constraint(equalTo: webPlayerView.topAnchor),
            webPlayer.leadingAnchor.constraint(equalTo: webPlayerView.leadingAnchor),
            webPlayer.trailingAnchor.constraint(equalTo: webPlayerView.trailingAnchor),
            webPlayer.bottomAnchor.constraint(equalTo: webPlayerView.bottomAnchor)
        ])
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

