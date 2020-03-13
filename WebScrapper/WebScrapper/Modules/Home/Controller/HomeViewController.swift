//
//  ViewController.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let controller = HomeController()
    
    let stockName: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Magazine Luiza (MGLU3)"
        label.textColor = .white
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .lightGray
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = HomeView()
        
//        controller.makeInfoMoney()
    }
}
