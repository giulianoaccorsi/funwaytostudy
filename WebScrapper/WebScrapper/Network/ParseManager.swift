//
//  NetworkManager.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

import Foundation
import SwiftSoup

class ParseManager {
    let service: NetworkService
    let site: String = "https://www.infomoney.com.br/cotacoes/magazine-luiza-mglu3/"
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    func parseHTML() -> [String] {
        var arrayParsed:[String] = []
        service.fetchHtmlString(site: site) { (html) in
            guard let html = html else{return}
            do {
                let doc: Document = try SwiftSoup.parse(html)
                for row in try! doc.select("tr") {
                    for element in try! row.select("td") {
                        let elementParsed = try! element.text()
                        arrayParsed.append(elementParsed)
                        print(elementParsed)
                    }
                }
            } catch {
                print("🤦🏻‍♂️")
            }
        }
        
        return arrayParsed
    }
    
}
