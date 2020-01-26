//
//  ViewController.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 21/01/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
    let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
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

extension HomeViewController: WKUIDelegate, WKNavigationDelegate {
}
