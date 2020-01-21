//
//  FavoriteController.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 19/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import Foundation

protocol FavoriteControllerDelegate: class {
    func addNewsFavorite()
}

class FavoriteController {
    
    let dataManager = DataManager()
    var delegate: FavoriteControllerDelegate?
    var arrayNewsSavedLocal: [NewsSaved] = []
    
    
    
    
    func loadAllNewsSaved() {
        dataManager.loadArrayNews { (arrayNewsSaved) in
            if let arrayNewsCoreData = arrayNewsSaved {
                self.arrayNewsSavedLocal = arrayNewsCoreData
            }
        }
    }
    
    func registerNewsSaved(article: Article, completion: (Bool)-> Void) {
        dataManager.registerNews(article: article, htmlString: htmlToString(article: article)) { (success) in
            if success {
                loadAllNewsSaved()
                completion(true)
                print("Deu bom ao registrar")
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
        dataManager.deleteNews(id: arrayNewsSavedLocal[index].objectID) { (success) in
            if success {
                loadAllNewsSaved()
                print("Deu Bom ao Deleter")
            }
        }
    }
    
    
    func getArrayCount() -> Int {
        return arrayNewsSavedLocal.count
    }
    
    func getArticle(index: Int) -> NewsSaved {
        return arrayNewsSavedLocal[index]
    }

}
