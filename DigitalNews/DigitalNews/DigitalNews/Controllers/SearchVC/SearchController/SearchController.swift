
//
//  File.swift
//  DigitalNews
//
//  Created by paulopr4 on 17/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation

protocol searchNewsControllerDelegate: class {
    func didFinishRequest()
    func finishRefresh()
}


class SearchController {
    let apiManager  = ApiManager()
    var arrayNews: [Article] = []
    var delegate: searchNewsControllerDelegate?
    var fetchMore: Bool = true
    var indexPageRequest: Int = 1
   
    
    func searchNews(word: String) {
        if fetchMore {
            apiManager.searchNews(word: word, page: indexPageRequest) { (newsArray, error) in
                if error == nil {
                    if let arraySuccess = newsArray {
                        self.arrayNews = arraySuccess
                        self.delegate?.finishRefresh()
                    }
                }else {
                }
            }
        }
    }
    
    func loadMoreNews() {
        if fetchMore {
            self.fetchMore = false
            ApiManager().loadMoreNews(page: self.indexPageRequest) { (arrayNews, error) in
                if error == nil {
                    if let array = arrayNews {
                        self.arrayNews.append(contentsOf: array)
                        self.indexPageRequest += 1
                        self.delegate?.didFinishRequest()
                    }
                }else {
                }
                self.fetchMore = true
            }
        }
    }
    
    func getArrayCount() -> Int {
        return arrayNews.count
    }
    
    func getArticle(index: Int) -> Article {
        return arrayNews[index]
    }
    
    
}
