//
//  LoginViewController.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 22/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

import FBSDKLoginKit


class LoginViewController: BaseViewController {
    

    @IBOutlet weak var buttonFacebook: FBLoginButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFacebook.layer.cornerRadius = 20
        buttonFacebook.backgroundColor = UIColor(red: 0.258, green: 0.395, blue: 0.737, alpha: 1.0)
        buttonFacebook.tintColor = .white
        
    }

    
    func getInformation(completion: @escaping (Bool) -> Void) {
        Settings.isAutoLogAppEventsEnabled = true
        Settings.isAdvertiserIDCollectionEnabled = true
        GraphRequest(graphPath: "/me", parameters: ["fields":"name,email,picture"]).start { (connection, result, error) in
            
            if let dict = result as? [String: Any] {
                if let picture = dict["picture"] as? [String:Any], let data = picture["data"] as? [String:Any], let url = data["url"] as? String {
                    UserDefaults.standard.set(dict["name"], forKey: "NomeFacebook")
                    print(url)
                    UserDefaults.standard.set(url, forKey: "FotoFacebook")
                    completion(true)
                    return
                }
            }
            
        }
        
        completion(false)
    }
    
    
    
    @IBAction func buttonClickedFB(_ sender: Any) {
        if AccessToken.isCurrentAccessTokenActive {
            getInformation { (success) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewsMain") as? UITabBarController else{return}
                    self.present(viewController, animated: true)
                }
            }
        }else {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile"], from: self) { (result, error) in
                if result?.token != nil{
                    print("logado")
                    self.getInformation(completion: { (success) in
                        if success {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewsMain") as? UITabBarController else {return}
                            self.present(viewController, animated: true)
                        }
                    })
                } else {
                    self.getInformation(completion: { (success) in
                        if success {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewsMain") as? UITabBarController else {return}
                            self.present(viewController, animated: true)
                        }
                    })
                }
            }
        }
    }
}


extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("deslogou")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled ?? true {
            print("cancelou")
        } else {
            getInformation { (success) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: "NewsMain") as? UITabBarController else {return}
                    self.present(viewController, animated: true)
                }
            }
        }
    }
    
    
}
