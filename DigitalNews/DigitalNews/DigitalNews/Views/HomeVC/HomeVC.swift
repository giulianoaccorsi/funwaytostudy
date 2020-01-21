//
//  ViewController.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 23/07/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import Lottie

class HomeVC: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NewsController?
    var refreshControl:UIRefreshControl = UIRefreshControl()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
   
        self.startAnimating()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.tintColor = UIColor(red: 0.998, green: 0.502, blue: 0.041, alpha: 1.0)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        

        
        
        controller = NewsController()
        controller?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.addSubview(refreshControl )
        
        controller?.getNews()
        
    }
    
    @objc private func darkModeEnabled(_ notification: Notification) {
        darkModeEnable()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        darkModeDisable()
        
    }
    
    func darkModeEnable() {
        self.tableView.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
//        self.tabBarController?.tabBar.barStyle = .blackTranslucent
        
    }
    
    func darkModeDisable() {
        self.tableView.backgroundColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        
    }
    
    @objc func refresh(sender: AnyObject) {
        self.controller?.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.valueChanged), name: Notification.Name("UserChangedValue"), object: nil)
    }
    
    @objc func valueChanged() {
        self.tableView.isHidden = true
        self.startAnimating()
        controller?.getNews()
    }


}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller?.getArrayCount() ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // somente 1 noticia por section
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.setupCell(article: (controller?.getArticle(index: indexPath.section))!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else {return}
        viewController.article = controller?.getArticle(index: indexPath.section).url
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tagertContentOffSet = (tableView.contentSize.height - tableView.frame.height)
        if scrollView.contentOffset.y * 2 > tagertContentOffSet {
            controller?.loadMoreNews()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoritarSwipe = UIContextualAction(style: .normal, title: "Favoritar") { [weak self](action, view, completionHandler) in
            guard let self = self else {
                return completionHandler(false)
            }
            
            FavoriteDataProvider.shared.registerNewsSaved(article: self.controller?.getArticle(index: indexPath.section) ?? Article(source: Source(id: "", name: ""), author: "", title: "", articleDescription: "", url: "", urlToImage: "", publishedAt: "", content: ""), completion: { (success) in
                if success {
                    print("Deu bom ao favoritar")
                }
            })
            completionHandler(true)
        }
        favoritarSwipe.backgroundColor = .orange
        favoritarSwipe.image = UIImage(named: "like")
        return UISwipeActionsConfiguration(actions: [favoritarSwipe])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ShareSwipe = UIContextualAction(style: .normal, title: "Compartilhar") { [weak self](action, view, completionHandler) in
            guard let self = self else {
                return completionHandler(false)
            }
            // Função Compartilhar
            let activtyController = UIActivityViewController(activityItems: [self.controller?.getArticle(index: indexPath.section).url as Any], applicationActivities: nil)
            self.present(activtyController, animated: true)
            completionHandler(true)
        }
        ShareSwipe.backgroundColor = UIColor(red: 0.259, green: 0.405, blue: 0.699, alpha: 1.0)
        ShareSwipe.image = UIImage(named: "share")
        return UISwipeActionsConfiguration(actions: [ShareSwipe])
    }

}

extension HomeVC: NewsControllerDelegate {
    func didFinishRequest() {
        self.tableView.reloadData()
    }
    
    func finishRefresh() {
        self.stopAnimating()
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
        self.tableView.isHidden = false
        
    }
    
    
    
}

