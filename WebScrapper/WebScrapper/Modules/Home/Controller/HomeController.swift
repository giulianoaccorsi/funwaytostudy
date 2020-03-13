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
    
//    func makeInfoMoney() -> InfoMoney {
//        let array:[String] = parseManager.parseHTML()
//        return InfoMoney(name: "",
//                         nameStock: "",
//                         time: "",
//                         fechamentoAnterior: array[ArrayRow.fechamentoAnterior.rawValue],
//                         abertura: array[ArrayRow.abertura.rawValue],
//                         quantidade: array[ArrayRow.quantidade.rawValue],
//                         volume: array[ArrayRow.volume.rawValue],
//                         minMax: array[ArrayRow.minMax.rawValue],
//                         dayVariation: array[ArrayRow.variationDay.rawValue],
//                         monthVariation: array[ArrayRow.variationMonth.rawValue],
//                         yearVariation: array[ArrayRow.variationYear.rawValue],
//                         twelveMonhts: array[ArrayRow.twelveWeeks.rawValue])
//    }
}
