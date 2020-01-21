//
//  UserController.swift
//  DigitalNews
//
//  Created by Giuliano Accorsi on 14/08/19.
//  Copyright © 2019 Giuliano Accorsi. All rights reserved.
//

import UIKit

enum TypeCountry: String {
    case ae = "Emirados Árabes Unidos"
    case ar = "Argentina"
    case at = "Áustria"
    case bg = "Bulgária"
    case be = "Bélgica"
    case br = "Brasil"
    case ca = "Canadá"
    case ch = "Suiça"
    case cn = "China"
    case co = "Colômbia"
    case cu = "Cuba"
    case cz = "República Checa"
    case de = "Alemanha"
    case eg = "Egito"
    case fr = "França"
    case gb = "Reino Unido"
    case hk = "Hong Kong"
    case it = "Itália"
    case jp = "Japão"
    case kr = "Coréia do Sul"
    case ma = "Marrocos"
    case ng = "Nigéria"
    case nz = "Nova Zelândia"
    case pl = "Polônia"
    case pt = "Portugal"
    case se = "Suécia"
    case ua = "Ucrânia"
    case us = "Estados Unidos"
    case ve = "Venezuela"
    case za = "África do Sul"
    
    var countryISO: String {
        get {
            return String(describing: self)
        }
    }
}

enum TypeCategory: String {
    case business = "Negócios"
    case entertainment = "Entretenimento"
    case general =  "Geral"
    case health =  "Saúde"
    case science = "Ciência"
    case sports = "Esportes"
    case technology = "Tecnologia"
    
    var categoryISO: String {
        get {
            return String(describing: self)
        }
    }
}

class UserController {  
    
    var arrayCountry: [TypeCountry] = [TypeCountry.ae, TypeCountry.ar, TypeCountry.at, TypeCountry.bg, TypeCountry.be, TypeCountry.br, TypeCountry.ca, TypeCountry.ch, TypeCountry.cn, TypeCountry.co, TypeCountry.cu, TypeCountry.cz, TypeCountry.de, TypeCountry.eg, TypeCountry.fr, TypeCountry.gb, TypeCountry.hk, TypeCountry.it, TypeCountry.jp, TypeCountry.kr, TypeCountry.ma, TypeCountry.ng, TypeCountry.nz, TypeCountry.pl, TypeCountry.pt, TypeCountry.se, TypeCountry.ua, TypeCountry.ve, TypeCountry.za]
    
    
    var arrayCategory:[TypeCategory] = [TypeCategory.business, TypeCategory.entertainment, TypeCategory.general, TypeCategory.health, TypeCategory.science, TypeCategory.sports, TypeCategory.technology]
    
    func getArrayCountry(index: Int) -> TypeCountry {
        return arrayCountry[index]
    }
    
    
    func numberOfRowsCountry() -> Int {
        return arrayCountry.count
    }
    
    func loadCountry(index: Int) -> String {
        return arrayCountry[index].rawValue
    }
    
    func numberOfRowsCategory() -> Int {
        return arrayCategory.count
    }
    
    func loadCategoryISO(index: Int) -> String {
        return arrayCategory[index].categoryISO
    }
    
    func loadCategoryName(index: Int) -> String {
        return arrayCategory[index].rawValue
    }
    
//    func getImageProfile() -> UIImage {
//        let url = UserDefaults.standard.url(forKey:"FotoFacebook")
//        if let urlObitda = url {
//            let data = try? Data(contentsOf: url!)
//            return UIImage(data: data!) ?? UIImage()
//        }
//        return UIImage()
//    }
    
    
}
