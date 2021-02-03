//
//  ParseManager.swift
//  Impacta
//
//  Created by Giuliano Accorsi on 02/02/21.
//  Copyright © 2021 Giuliano Accorsi. All rights reserved.
//

import Foundation
import SwiftSoup

class ParseManager {
    let service: NetworkService
    let html: String
    init(service: NetworkService = NetworkService(), html: String) {
        self.service = service
        self.html = html
    }
    func parseHTML() -> [String] {
        let arrayParsed:[String] = []
        service.fetchHtmlString(site: html) { (html) in
            guard let html = html else{return}
            do {
                let doc: Document = try SwiftSoup.parse(html)
                print(doc)
//                for row in try! doc.select("tr") {
//                    for element in try! row.select("td") {
//                        let elementParsed = try! element.text()
//                        arrayParsed.append(elementParsed)
//                        print(elementParsed)
//                    }
//                }
            } catch {
                print("🤦🏻‍♂️")
            }
        }
        
        return arrayParsed
    }
    
}
