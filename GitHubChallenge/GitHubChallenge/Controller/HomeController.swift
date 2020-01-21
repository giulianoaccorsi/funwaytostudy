//
//  HomeController.swift
//  GitHubChallenge
//
//  Created by Giuliano Accorsi on 05/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol HomeControllerDelegate: class {
    func finishRefresh()
    func didFinishRequest()
}

// MARK: - Controller
class HomeController {
    private var arrayGit: [Item] = []
    weak var delegate: HomeControllerDelegate?
    private var fetchMore: Bool = true
    private var indexOfPageRequest: Int = 1
    
    func arrayGetCount() -> Int {
        return self.arrayGit.count
    }
    
    func getItem(index: IndexPath) -> Item {
        return arrayGit[index.row]
    }
    
    func updateWithPullRefresh() {
        if fetchMore {
            APIManager().updateInformation { (arrayItems, success) in
                if success {
                    if let array = arrayItems {
                        self.arrayGit = array
                        self.delegate?.finishRefresh()
                    }
                } else {
                }
            }
        }
    }
    
    
    func loadMorePages() {
        if fetchMore {
            self.fetchMore = false
            APIManager().loadInformation(page: self.indexOfPageRequest) { (arrayItems, success) in
                if success {
                    if let array = arrayItems {
                        self.arrayGit.append(contentsOf: array)
                        self.indexOfPageRequest += 1
                        self.delegate?.didFinishRequest()
                    }
                } else {
                }
                self.fetchMore = true
            }
        }

    }
}
