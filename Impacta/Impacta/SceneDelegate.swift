//
//  SceneDelegate.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 21/01/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let rootViewController = HomeTabBarController()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    
}

