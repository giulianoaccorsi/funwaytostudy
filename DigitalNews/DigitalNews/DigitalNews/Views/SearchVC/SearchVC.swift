//
//  SearchVC.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 06/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController {
    
    var controller: SearchController?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        controller = SearchController()
        
        searchBar.delegate = self
        controller?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
        }else {
            darkModeDisable()
        }
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        darkModeEnable()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        darkModeDisable()
        
    }
    
    func darkModeEnable() {
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.tableView.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        self.searchBar.barStyle = .blackTranslucent
        self.view.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        self.searchBar.barTintColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
        
    }
    
    func darkModeDisable() {
        self.navigationController?.navigationBar.barStyle = .default
        self.tableView.backgroundColor = .white
        self.searchBar.barStyle = .default
        self.searchBar.barTintColor = .white
        self.view.backgroundColor = .white
        
    }
    
    
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let darkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if darkMode {
            darkModeEnable()
            cell.backgroundColor = UIColor(red: 0.341, green: 0.341, blue: 0.341, alpha: 1.0)
            cell.textLabel?.textColor = .white
        }else {
            darkModeDisable()
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoritarSwipe = UIContextualAction(style: .normal, title: "Favoritar") { [weak self](action, view, completionHandler) in
            guard let self = self else {
                return completionHandler(false)
            }
            
            FavoriteDataProvider.shared.registerNewsSaved(article: self.controller?.getArticle(index: indexPath.row) ?? Article(source: Source(id: "", name: ""), author: "", title: "", articleDescription: "", url: "", urlToImage: "", publishedAt: "", content: ""), completion: { (success) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.getArrayCount() ?? 0
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else {return UITableViewCell()}
        cell.setupCell(title: controller?.getArticle(index: indexPath.row) ?? Article(source: Source(id: "", name: ""), author: "", title: "", articleDescription: "", url: "", urlToImage: "", publishedAt: "", content: ""))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Detail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else {return}
        viewController.saved = controller?.getArticle(index: indexPath.row).url
        viewController.article = controller?.getArticle(index: indexPath.row).url
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tagertContentOffSet = (tableView.contentSize.height - tableView.frame.height)
        if scrollView.contentOffset.y > tagertContentOffSet {
            controller?.loadMoreNews()
        }
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.startAnimating()
        controller?.searchNews(word: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    
}

extension SearchVC: searchNewsControllerDelegate {
    func didFinishRequest() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
        self.stopAnimating()
    }
    
    func finishRefresh() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
        self.stopAnimating()
        
    }
    
    
}



