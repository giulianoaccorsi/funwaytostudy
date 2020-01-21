//
//  ViewController.swift
//  GitHubChallenge
//
//  Created by Giuliano Accorsi on 05/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Outlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let controller:HomeController = HomeController()
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(refreshControl)
        self.tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        self.controller.delegate = self
        self.controller.loadMorePages()
    }
    
    
    
    @objc func refresh(sender: AnyObject) {
        self.controller.updateWithPullRefresh()
    }
    
    
}

// MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.arrayGetCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        cell.tag = indexPath.row
        cell.setupCell(item: self.controller.getItem(index: indexPath))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {        
       let tagertContentOffSet = (tableView.contentSize.height - tableView.frame.height)
        if scrollView.contentOffset.y > tagertContentOffSet {
            controller.loadMorePages()
        }
    }
    

    
}

// MARK: - HomeController Delegate
extension HomeViewController: HomeControllerDelegate {
    func finishRefresh() {
        self.tableView.isHidden = false
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func didFinishRequest() {
        self.tableView.reloadData()
        self.tableView.isHidden = false
        self.activityIndicator.isHidden = true
    }
}

