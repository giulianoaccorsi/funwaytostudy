//
//  HomeController.swift
//  WebScrapper
//
//  Created by Giuliano Accorsi on 12/03/20.
//  Copyright © 2020 Giuliano Accorsi. All rights reserved.
//

enum ArrayRow: Int {
    case fechamentoAnterior = 1
    case abertura = 3
    case negocios = 5
    case quantidade = 7
    case volume = 9
    case minMax = 11
    case variationDay = 13
    case variationMonth = 15
    case variationYear = 17
    case twelveWeeks = 19
}

import Foundation
class HomeController {
    var parseManager: ParseManager
    init(parseManager: ParseManager = ParseManager()) {
        self.parseManager = parseManager
    }
    
    func makeInfoMoney() -> Void {
        let array:[String] = parseManager.parseHTML()
        parseManager.parseHTML()
    }
}
