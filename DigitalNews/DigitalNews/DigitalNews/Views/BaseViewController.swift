//
//  BaseViewController.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 22/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    
    let starAnimationView = AnimationView()
    let starAnimation = Animation.named("loadingAPI")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startAnimating() {
        starAnimationView.isHidden = false
        starAnimationView.animation = starAnimation
        starAnimationView.frame =  self.view.frame
        starAnimationView.loopMode = .loop
        starAnimationView.play()
        self.view.addSubview(starAnimationView)
    
        
    }
    func stopAnimating() {
        starAnimationView.stop()
        starAnimationView.isHidden = true
        
        
    }
    
    func showErros(error: NSError) {
        let alert: UIAlertController = UIAlertController(title: "Erro :(", message: error.localizedDescription, preferredStyle: .alert)
        
        let actionOk: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
