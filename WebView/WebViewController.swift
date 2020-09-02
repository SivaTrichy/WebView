//
//  ViewController.swift
//  Webview
//
//  Created by Temp on 14/07/20.
//  Copyright © 2020 Temp. All rights reserved.
//
// Git Change test

import UIKit
import WebKit
import Network

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate
{
    // - Variables
    let url = URL(string: "https://apple.com")!
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        activityIndicator.startAnimating()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // - Network Monitor
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    if self.webView.url != nil {
                        self.webView.reload()
                    } else {
                        self.webView.load(URLRequest(url: self.url))
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
    }
    
    func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        webView.addSubview(activityIndicator)
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
        })
        self.present(alert, animated: true)
    }
}

