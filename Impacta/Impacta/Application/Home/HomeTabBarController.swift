//
//  HomeTabBarController.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 25/01/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = .cinzaImpacta
        
        let firstViewController = HomeViewController()
        firstViewController.tabBarItem = UITabBarItem(title: Strings.homeTitle, image: UIImage(named: Strings.home), selectedImage: UIImage(named: Strings.homeFilled))
        firstViewController.tabBarItem.tag = 0
        
        let secondViewController = ScheduleViewController()
        secondViewController.tabBarItem = UITabBarItem(title: Strings.scheduleTitle, image: UIImage(named: Strings.schedule), selectedImage: UIImage(named: Strings.scheduleFilled))
        secondViewController.tabBarItem.tag = 1
        
        let thirdViewController = GradesViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: Strings.settingsTitle, image: UIImage(named: Strings.settings), selectedImage: UIImage(named: Strings.settingsFilled))
        thirdViewController.tabBarItem.tag = 2
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
    }
    
}
