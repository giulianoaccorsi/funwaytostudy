//
//  FavoriteSingleton.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 20/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation
class FavoriteDataProvider {
    static let shared = FavoriteDataProvider()
     var arraySaved:[NewsSaved] = []
     let dataManager = DataManager()
    
    func loadAllNewsSaved(completion: (Bool) -> Void) {
        dataManager.loadArrayNews { (arrayNewsSaved) in
            if let arrayNewsCoreData = arrayNewsSaved {
                self.arraySaved = arrayNewsCoreData
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    func registerNewsSaved(article: Article, completion: (Bool)-> Void) {
        dataManager.registerNews(article: article, htmlString: htmlToString(article: article)) { (success) in
            if success {
                loadAllNewsSaved(completion: { (success) in
                    if success {
                        print("Deu bom ao registrar")
                        completion(true)
                    }
                })
            }else {
                completion(false)
            }
        }
    }
    
    func htmlToString(article: Article) -> String {
        if let url = URL(string: article.url ?? "") {
            do {
                let contents = try String(contentsOf: url)
                print("Converteu de HTML Pra String")
                return contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        return ""
    }
    
     func deleteNewsSaved(index: Int, completion: (Bool) -> Void) {
        dataManager.deleteNews(id: arraySaved[index].objectID) { (success) in
            if success {
                print("Deu Bom ao Deleter")
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    
     func getArrayCount() -> Int {
        return arraySaved.count
    }
    
     func getNewsSaved(index: Int) -> String {
        return arraySaved[index].url ?? ""
    }
    func loadNewsSaved(index: Int) -> NewsSaved {
        return arraySaved[index]
    }
    
    func getFullArticle(index: Int) -> String {
        return arraySaved[index].urlOriginal ?? ""
    }
    
}


