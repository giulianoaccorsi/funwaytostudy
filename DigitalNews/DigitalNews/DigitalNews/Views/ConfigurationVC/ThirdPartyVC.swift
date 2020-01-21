//
//  ThirdPartyVC.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 13/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class ThirdPartyVC: UIViewController {
    @IBOutlet weak var newsapi: UILabel!
    @IBOutlet weak var icons: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel))
        icons.isUserInteractionEnabled = true
        icons.addGestureRecognizer(tap)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel2))
        newsapi.isUserInteractionEnabled = true
        newsapi.addGestureRecognizer(tap2)
    }
    
    // And that's the function :)
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: "https://icons8.com/")
    }
    
    @objc func onClicLabel2(sender:UITapGestureRecognizer) {
        openUrl(urlString: "https://newsapi.org/")
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

}
