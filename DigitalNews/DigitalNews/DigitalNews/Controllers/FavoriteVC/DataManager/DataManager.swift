//
//  DataManager.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 20/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit
import CoreData

//: MARK - Data Manager
class DataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    var arrayNews:[NewsSaved] = []
    var news: NewsSaved?
    
    
    
    
    func loadArrayNews(completion: ([NewsSaved]?)->Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsSaved")
        do {
            let results = try context.fetch(fetchRequest)
            arrayNews = results as? [NewsSaved] ?? []
            completion(arrayNews)
        }catch {
            print("Erro loadData() - DataManager")
            completion(nil)
        }
    }
    
    func registerNews(article: Article, htmlString: String, completion:(Bool) -> Void) {
        let context = persistentContainer.viewContext
        let news = NewsSaved(context: context)
        
        news.url = htmlString
        news.descNews = article.articleDescription ?? ""
        news.title = article.title ?? ""
        news.urlToImage = article.urlToImage
        news.source = article.source?.name
        news.urlOriginal = article.url
        

        do {
            try context.save()
            print("Conseguiu salvar a noticia CoreData :D")
            arrayNews.append(news)
            completion(true)
        }catch {
            print("Deu Ruim !! registerNews() - DataManager")
            completion(false)
        }
        
    }
    
    func deleteNews(id: NSManagedObjectID, completion: (Bool)-> Void) {
        let context = persistentContainer.viewContext
        let news = context.object(with: id)
        context.delete(news)
        
        do {
            try context.save()
            completion(true)
        }catch {
            print("Erro deleteNews() - DataManager")
            completion(false)
        }
        
    }

}



