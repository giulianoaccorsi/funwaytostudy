//
//  ScheduleViewController.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 25/01/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit
import WebKit

class ScheduleViewController: UIViewController {
    let teste1 = ""
    let teste2 = ""
    
    let LOGIN_JS = """
    function login() {
        if (document.getElementById('deslogin')[0] != null)
            document.getElementById('deslogin')[0].value = \("1903160");
        if (document.getElementById('dessenhalogin')[0] != null)
            document.getElementById('dessenhalogin')[0].value = \("15309639");

        if (document.getElementsByClassName('btn btn-login')[0] != null)
                document.getElementsByClassName('btn btn-login')[0].click();
        }
    }
    login();
    """
    
    let webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.setNeedsLayout()
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
        if let url = URL(string: "https://account.impacta.edu.br/") {
            webView.load(URLRequest(url: url))
        }else {
            print("faio")
        }
    }
    
    func setupUI(){
        self.view.addSubview(self.webView)
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
}

extension ScheduleViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let jsFile = Bundle.main.url(forResource: "Login", withExtension: "js") else {
            return
        }
        
        do {
            let injectJS = try String(contentsOf: jsFile)
            let formatted = String(format: injectJS, "1903160", "15309639")
            webView.evaluateJavaScript(formatted) { (value, error) in
                print(error)
            }
        } catch {
            
        }
    }
}
