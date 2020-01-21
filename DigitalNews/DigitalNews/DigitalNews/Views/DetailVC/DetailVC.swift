//
//  DetailVC.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 07/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import WebKit


class DetailVC: BaseViewController {
    @IBOutlet weak var webNew: WKWebView!

    
    var article: String?
    var saved: String?
    
    
    override func viewDidLoad() {
        let prefereces = WKPreferences()
        prefereces.javaScriptEnabled = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = prefereces
        webNew.navigationDelegate = self
        webNew.layer.cornerRadius = 30
        webNew.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        darkModeEnable()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        darkModeDisable()
        
    }
    
    func darkModeEnable() {
        self.view.backgroundColor = UIColor(red: 0.449, green: 0.449, blue: 0.449, alpha: 1.0)
        
    }
    
    func darkModeDisable() {
        self.view.backgroundColor = .white
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            if let urlString = article {
                let url = URL(string: urlString)
                let request = URLRequest(url: url!)
                webNew.allowsBackForwardNavigationGestures = true
                webNew.allowsLinkPreview = false   //Padrão true
                webNew.navigationDelegate = self
                webNew.uiDelegate = self
                webNew.load(request)
            }
        }else{
            print("Internet Connection not Available!")
            if let urlSaved = saved {
                webNew.loadHTMLString(urlSaved, baseURL: nil)
            }
        }
        
        
        
        
        
    }
}


extension DetailVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        self.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
